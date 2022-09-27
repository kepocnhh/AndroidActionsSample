package org.kepocnhh.aas.implementation.module.foo

import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext
import org.kepocnhh.aas.foundation.provider.injection.Injection
import org.kepocnhh.aas.implementation.util.androidx.lifecycle.AbstractViewModel

internal class FooViewModel(private val injection: Injection) : AbstractViewModel() {
    @Suppress("MagicNumber")
    fun requestOne(onSuccess: (Int) -> Unit) {
        injection.launch {
            withContext(injection.coroutines.io) {
                delay(3_000)
            }
            onSuccess(1)
        }
    }

    @Suppress("MagicNumber")
    fun requestTwo(onSuccess: (Int) -> Unit) {
        injection.launch {
            withContext(injection.coroutines.io) {
                delay(3_000)
            }
            onSuccess(2)
        }
    }
}
