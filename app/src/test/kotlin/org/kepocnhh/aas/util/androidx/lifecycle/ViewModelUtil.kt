package org.kepocnhh.aas.util.androidx.lifecycle

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.runBlocking
import org.kepocnhh.aas.foundation.provider.injection.Injection

inline fun <reified T : ViewModel> Injection.viewModel(): T {
    return T::class.java.getConstructor(Injection::class.java).newInstance(this)
}

inline fun <reified T : ViewModel> Injection.runViewModel(crossinline block: suspend (T) -> Unit) {
    runBlocking { block(viewModel()) }
}
