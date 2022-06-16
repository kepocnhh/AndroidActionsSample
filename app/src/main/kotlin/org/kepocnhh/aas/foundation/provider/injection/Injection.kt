package org.kepocnhh.aas.foundation.provider.injection

import org.kepocnhh.aas.foundation.provider.coroutines.CoroutinesProvider
import java.io.File

interface Injection {
    val cacheDir: File
    val coroutines: CoroutinesProvider
}
