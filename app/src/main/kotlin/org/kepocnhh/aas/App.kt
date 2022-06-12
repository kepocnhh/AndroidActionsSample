package org.kepocnhh.aas

import android.app.Application
import androidx.compose.runtime.Composable
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.ViewModelStoreOwner
import androidx.lifecycle.viewmodel.compose.LocalViewModelStoreOwner
import org.kepocnhh.aas.foundation.provider.injection.Injection
import java.io.File
import kotlin.coroutines.CoroutineContext
import kotlin.coroutines.EmptyCoroutineContext

private class AppInjection(
    override val cacheDir: File,
    override val context: CoroutineContext,
) : Injection

class App : Application() {
    companion object {
        private var _viewModelFactory: ViewModelProvider.Factory? = null
        val viewModelFactory: ViewModelProvider.Factory get() {
            return requireNotNull(_viewModelFactory)
        }

        @Composable
        inline fun <reified T : ViewModel> viewModel(
            owner: ViewModelStoreOwner = LocalViewModelStoreOwner.current ?: TODO()
        ): T {
            return ViewModelProvider(owner, viewModelFactory).get(T::class.java)
        }
    }

    override fun onCreate() {
        super.onCreate()
        val injection: Injection = AppInjection(
            cacheDir = cacheDir,
            context = EmptyCoroutineContext,
        )
        _viewModelFactory = object : ViewModelProvider.Factory {
            override fun <U : ViewModel> create(modelClass: Class<U>): U {
                return modelClass.getConstructor(Injection::class.java).newInstance(injection)
            }
        }
    }
}
