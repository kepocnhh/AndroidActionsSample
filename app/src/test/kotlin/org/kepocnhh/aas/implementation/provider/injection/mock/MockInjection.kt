package org.kepocnhh.aas.implementation.provider.injection.mock

import kotlinx.coroutines.asCoroutineDispatcher
import org.kepocnhh.aas.foundation.provider.injection.Injection
import java.io.File
import java.nio.file.Files
import java.util.concurrent.Executors
import kotlin.coroutines.CoroutineContext

class MockInjection(
    override val cacheDir: File = Files.createTempDirectory("mock_prefix").toFile(),
    override val context: CoroutineContext = Executors.newSingleThreadExecutor()
        .asCoroutineDispatcher()
) : Injection
