package org.kepocnhh.aas.implementation.module.foo

import org.junit.Assert.assertEquals
import org.junit.Test
import org.kepocnhh.aas.implementation.provider.injection.mock.MockInjection
import org.kepocnhh.aas.util.androidx.lifecycle.runViewModel
import org.kepocnhh.aas.util.org.junit.JUnitUtil
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

internal class FooViewModelTest {
    @Test(timeout = JUnitUtil.timeout)
    fun requestOneTest() {
        val injection = MockInjection()
        injection.runViewModel<FooViewModel> { viewModel ->
//            val number = suspendCoroutine<Int> { continuation ->
//                viewModel.requestOne { time ->
//                    continuation.resume(time)
//                }
//            }
//            assertEquals(1, number)
        }
    }
}
