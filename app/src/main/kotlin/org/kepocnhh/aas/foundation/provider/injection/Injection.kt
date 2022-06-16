package org.kepocnhh.aas.foundation.provider.injection

import org.kepocnhh.aas.foundation.provider.coroutines.CoroutinesProvider
import java.io.File

internal interface Injection {
    val cacheDir: File
    val coroutines: CoroutinesProvider
}
