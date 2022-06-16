package org.kepocnhh.aas.foundation.provider.coroutines

import kotlin.coroutines.CoroutineContext

class CoroutinesProvider(
    val main: CoroutineContext,
    val io: CoroutineContext
)
