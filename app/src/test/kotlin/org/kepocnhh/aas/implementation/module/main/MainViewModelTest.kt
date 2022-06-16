package org.kepocnhh.aas.implementation.module.main

import org.junit.Assert.assertTrue
import org.junit.Test
import org.kepocnhh.aas.implementation.provider.injection.mock.MockInjection
import org.kepocnhh.aas.util.androidx.lifecycle.runViewModel
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

class MainViewModelTest {
    @Test(timeout = 10_000)
    fun logoutTest() {
//        val injection = MockInjection()
//        injection.runViewModel<MainViewModel> { viewModel ->
//            val time = suspendCoroutine<Long> { continuation ->
//                viewModel.requestTime { time ->
//                    continuation.resume(time)
//                }
//            }
//            assertTrue(time <= System.currentTimeMillis())
//        }
    }
}
