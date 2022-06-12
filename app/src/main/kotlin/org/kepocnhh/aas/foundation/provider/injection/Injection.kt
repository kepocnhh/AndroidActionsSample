package org.kepocnhh.aas.foundation.provider.injection

import java.io.File
import kotlin.coroutines.CoroutineContext

interface Injection {
    val cacheDir: File
    val context: CoroutineContext
}
