object Version {
    const val jvmTarget = "1.8"
    const val kotlin = "1.5.31"

    object Android {
        const val toolsBuildGradle = "7.1.3"
        const val compileSdk = 31
        const val minSdk = 23
        const val targetSdk = compileSdk
    }

    object Application {
        const val code = 1
        const val name = "0.$code"
    }
}
