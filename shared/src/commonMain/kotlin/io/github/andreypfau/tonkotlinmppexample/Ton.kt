package io.github.andreypfau.tonkotlinmppexample

import io.ktor.util.*
import io.ktor.utils.io.core.*
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import org.ton.api.liteclient.config.LiteClientConfigGlobal
import org.ton.api.pk.PrivateKeyEd25519
import org.ton.api.pub.PublicKeyEd25519
import org.ton.bitstring.Bits256
import org.ton.bitstring.toBitString
import org.ton.block.StateInit
import org.ton.boc.BagOfCells
import org.ton.cell.CellBuilder
import org.ton.contract.wallet.WalletContract
import org.ton.contract.wallet.WalletV4R2Contract
import org.ton.crypto.base64
import org.ton.crypto.decodeHex
import org.ton.crypto.encodeHex
import org.ton.lite.client.LiteClient
import org.ton.mnemonic.Mnemonic
import org.ton.tlb.storeTlb
import kotlin.native.Platform
import kotlin.time.ExperimentalTime
import kotlin.time.TimeSource

class Ton {

    val CODE =
        BagOfCells(base64("te6cckECFAEAAtQAART/APSkE/S88sgLAQIBIAIDAgFIBAUE+PKDCNcYINMf0x/THwL4I7vyZO1E0NMf0x/T//QE0VFDuvKhUVG68qIF+QFUEGT5EPKj+AAkpMjLH1JAyx9SMMv/UhD0AMntVPgPAdMHIcAAn2xRkyDXSpbTB9QC+wDoMOAhwAHjACHAAuMAAcADkTDjDQOkyMsfEssfy/8QERITAubQAdDTAyFxsJJfBOAi10nBIJJfBOAC0x8hghBwbHVnvSKCEGRzdHK9sJJfBeAD+kAwIPpEAcjKB8v/ydDtRNCBAUDXIfQEMFyBAQj0Cm+hMbOSXwfgBdM/yCWCEHBsdWe6kjgw4w0DghBkc3RyupJfBuMNBgcCASAICQB4AfoA9AQw+CdvIjBQCqEhvvLgUIIQcGx1Z4MesXCAGFAEywUmzxZY+gIZ9ADLaRfLH1Jgyz8gyYBA+wAGAIpQBIEBCPRZMO1E0IEBQNcgyAHPFvQAye1UAXKwjiOCEGRzdHKDHrFwgBhQBcsFUAPPFiP6AhPLassfyz/JgED7AJJfA+ICASAKCwBZvSQrb2omhAgKBrkPoCGEcNQICEekk30pkQzmkD6f+YN4EoAbeBAUiYcVnzGEAgFYDA0AEbjJftRNDXCx+AA9sp37UTQgQFA1yH0BDACyMoHy//J0AGBAQj0Cm+hMYAIBIA4PABmtznaiaEAga5Drhf/AABmvHfaiaEAQa5DrhY/AAG7SB/oA1NQi+QAFyMoHFcv/ydB3dIAYyMsFywIizxZQBfoCFMtrEszMyXP7AMhAFIEBCPRR8qcCAHCBAQjXGPoA0z/IVCBHgQEI9FHyp4IQbm90ZXB0gBjIywXLAlAGzxZQBPoCFMtqEssfyz/Jc/sAAgBsgQEI1xj6ANM/MFIkgQEI9Fnyp4IQZHN0cnB0gBjIywXLAlAFzxZQA/oCE8tqyx8Syz/Jc/sAAAr0AMntVGliJeU=")).first()

    suspend fun initLiteClientAsync(): LiteClient = coroutineScope {
        val json = Json {
            ignoreUnknownKeys = true
        }
        val config = json.decodeFromString<LiteClientConfigGlobal>(LITE_CLIENT_CONFIG_JSON)
        LiteClient(coroutineContext, config)
    }

    fun initLiteClient() = runBlocking {
        initLiteClientAsync()
    }

    @Throws(Exception::class)
    fun getLastBlockId(liteClient: LiteClient): String = runBlocking {
        liteClient.getLastBlockId().toString()
    }

    suspend fun calculateKeyPair(mnemonics: List<String>) = coroutineScope {
        val seed = Mnemonic.toSeed(mnemonics)
        val pk = PrivateKeyEd25519(seed)
        val pub = pk.publicKey()

        TonKeyPair(pk.key.base64(), pub.key.base64())
    }

    fun hexToBase(hex: String): String {
        val array = hex.decodeHex()
        return base64(array)
    }

    fun baseToHex(base64: String): String {
        val array = base64.decodeBase64Bytes()
        return org.ton.crypto.hex(array)
    }

    fun keyToHex(pbKey: String): String {
        val bitString = pbKey.decodeBase64Bytes().toBitString()
        val key = Bits256(bitString)

        return key.hex()
    }

    fun walletAddress(pbKey: String, isUserFriendly: Boolean = true): String {
        val publicKey = PublicKeyEd25519(base64(pbKey))
        val wallet = WalletV4R2Contract(publicKey)
        val address = wallet.address.toString(userFriendly = isUserFriendly)

        return address
    }

    fun createStateInit(publicKey: String): String {
        val byteArray = publicKey.decodeBase64Bytes().toBitString()
        val key = Bits256(byteArray)
        val wallet = WalletV4R2Contract(PublicKeyEd25519(base64(publicKey)))

        val data = CellBuilder.createCell {
            storeUInt(0, 32) // seqno
            storeUInt(WalletContract.DEFAULT_WALLET_ID, 32)
            storeBits(key)
            storeBit(false) // plugins
            endCell()
        }

        val stateInit = StateInit(
            code = CODE,
            data = data
        )

        val stateInitCodec = StateInit.tlbCodec()
        val stateInitCell = CellBuilder.createCell { storeTlb(stateInitCodec, stateInit) }

        return stateInitCell.hash(level = 0).encodeHex()
    }

    @OptIn(ExperimentalStdlibApi::class, ExperimentalTime::class)
    suspend fun generateMnemonic(): List<String> = coroutineScope {
        val channel = Channel<List<String>>()
        val time = TimeSource.Monotonic.markNow()
        val tasks = async {
            List(Platform.getAvailableProcessors()) { num ->
                async {
                    while (isActive) {
                        val mnemonics = Mnemonic.generate()
                        // sometimes mnemonic can be both basic and password seed, retry generate
                        if (Mnemonic.isPasswordSeed(Mnemonic.toEntropy(mnemonics))) {
                            println("Found password seed in basic mnemonic, retry...")
                            continue
                        }
                        channel.send(mnemonics)
                        break
                    }
                }
            }
        }
        val mnemonics = channel.receive()
        println("Mnemonic generated for ${time.elapsedNow()}")
        tasks.cancel() // cancel non-completed tasks
        return@coroutineScope mnemonics
    }
}
