package org.kepocnhh.aas.implementation.provider.injection.mock

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.asCoroutineDispatcher
import org.kepocnhh.aas.foundation.provider.coroutines.CoroutinesProvider
import org.kepocnhh.aas.foundation.provider.injection.Injection
import java.io.File
import java.nio.file.Files
import java.util.concurrent.Executors

internal class MockInjection(
    override val cacheDir: File = Files.createTempDirectory("mock_prefix").toFile(),
    override val coroutines: CoroutinesProvider = CoroutinesProvider(
        main = Executors.newSingleThreadExecutor()
            .asCoroutineDispatcher(),
        io = Dispatchers.IO
    )
) : Injection
