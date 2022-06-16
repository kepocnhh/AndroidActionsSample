package org.kepocnhh.aas.implementation.util.androidx.lifecycle

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import org.kepocnhh.aas.foundation.provider.injection.Injection

abstract class AbstractViewModel : ViewModel() {
    protected fun Injection.launch(block: suspend CoroutineScope.() -> Unit): Job {
        return viewModelScope.launch(coroutines.main, block = block)
    }
}
