package io.github.andreypfau.tonkotlinmppexample

import org.ton.bitstring.Bits256

data class TonKeyPair(val privateKey: String, val publicKey: String)
data class BitsTonKeyPair(val privateKey: ByteArray, val publicKey: ByteArray)
