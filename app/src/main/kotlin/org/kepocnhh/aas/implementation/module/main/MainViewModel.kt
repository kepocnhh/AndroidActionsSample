package org.kepocnhh.aas.implementation.module.main

import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext
import org.kepocnhh.aas.foundation.provider.injection.Injection
import org.kepocnhh.aas.implementation.util.androidx.lifecycle.AbstractViewModel

internal class MainViewModel(private val injection: Injection) : AbstractViewModel() {
    @Suppress("MagicNumber")
    fun requestTime(onSuccess: (Long) -> Unit) {
        injection.launch {
            withContext(injection.coroutines.io) {
                delay(3_000)
            }
            onSuccess(System.currentTimeMillis())
        }
    }
}
