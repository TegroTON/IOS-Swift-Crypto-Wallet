package io.github.andreypfau.tonkotlinmppexample

import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.selects.select
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import org.ton.api.liteclient.config.LiteClientConfigGlobal
import org.ton.lite.client.LiteClient
import org.ton.mnemonic.Mnemonic
import kotlin.native.Platform
import kotlin.random.Random

class Ton {
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

    @OptIn(ExperimentalStdlibApi::class)
    fun generateMnemonic(): List<String> = runBlocking {
        val channel = Channel<List<String>>()
        val tasks = async {
            List(Platform.getAvailableProcessors()) { num ->
                async {
                    println("Mnemonic generation thread $num started")
                    while (isActive) {
                        val mnemonics = Mnemonic.generate()
                        // sometimes mnemonic can be both basic and password seed, retry generate
                        if (Mnemonic.isPasswordSeed(Mnemonic.toEntropy(mnemonics))) {
                            println("Found password seed in basic mnemonic, retry...")
                            continue
                        }
                        println("Mnemonic generation $num completed")
                        channel.send(mnemonics)
                        break
                    }
                }
            }
        }
        val mnemonics = channel.receive()
        tasks.cancel() // cancel non-completed tasks
        return@runBlocking mnemonics
    }
}