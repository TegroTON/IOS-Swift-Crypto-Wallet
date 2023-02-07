package io.github.andreypfau.tonkotlinmppexample

import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import org.ton.api.liteclient.config.LiteClientConfigGlobal
import org.ton.lite.client.LiteClient
import org.ton.mnemonic.Mnemonic
import kotlin.native.Platform
import kotlin.time.ExperimentalTime
import kotlin.time.TimeSource

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