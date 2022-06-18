package org.kepocnhh.aas.foundation.provider.coroutines

import kotlin.coroutines.CoroutineContext

internal class CoroutinesProvider(
    val main: CoroutineContext,
    val io: CoroutineContext
)
