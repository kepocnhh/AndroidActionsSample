package org.kepocnhh.aas

import android.app.Application
import androidx.compose.runtime.Composable
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.ViewModelStoreOwner
import androidx.lifecycle.viewmodel.compose.LocalViewModelStoreOwner
import kotlinx.coroutines.Dispatchers
import org.kepocnhh.aas.foundation.provider.coroutines.CoroutinesProvider
import org.kepocnhh.aas.foundation.provider.injection.Injection
import java.io.File
import kotlin.coroutines.EmptyCoroutineContext

private class AppInjection(
    override val cacheDir: File,
    override val coroutines: CoroutinesProvider,
) : Injection

internal class App : Application() {
    @Suppress("InjectDispatcher")
    override fun onCreate() {
        super.onCreate()
        val coroutines = CoroutinesProvider(
            main = EmptyCoroutineContext,
            io = Dispatchers.IO
        )
        val injection: Injection = AppInjection(
            cacheDir = cacheDir,
            coroutines = coroutines,
        )
        _viewModelFactory = object : ViewModelProvider.Factory {
            override fun <U : ViewModel> create(modelClass: Class<U>): U {
                return modelClass.getConstructor(Injection::class.java).newInstance(injection)
            }
        }
    }

    companion object {
        private var _viewModelFactory: ViewModelProvider.Factory? = null
        val viewModelFactory: ViewModelProvider.Factory
            get() {
                return requireNotNull(_viewModelFactory)
            }

        @Composable
        inline fun <reified T : ViewModel> viewModel(
            owner: ViewModelStoreOwner = LocalViewModelStoreOwner.current
                ?: error("Local view model store does not exist!")
        ): T {
            return ViewModelProvider(owner, viewModelFactory)[T::class.java]
        }
    }
}
