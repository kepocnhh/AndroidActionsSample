package org.kepocnhh.aas.implementation.module.main

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext
import org.kepocnhh.aas.foundation.provider.injection.Injection
import org.kepocnhh.aas.implementation.util.androidx.lifecycle.AbstractViewModel

class MainViewModel(private val injection: Injection) : AbstractViewModel() {
    fun requestTime(onSuccess: (Long) -> Unit) {
        injection.launch {
            withContext(Dispatchers.IO) {
                delay(3_000)
            }
            onSuccess(System.currentTimeMillis())
        }
    }
}
