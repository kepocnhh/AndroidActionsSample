object Version {
    const val jvmTarget = "1.8"
    const val kotlin = "1.5.31"
    const val jacoco = "0.8.7"
    const val ktlint = "0.45.2"
    const val detekt = "1.20.0"

    object Android {
        const val toolsBuildGradle = "7.1.3"
        const val compileSdk = 31
        const val minSdk = 23
        const val targetSdk = compileSdk
        const val lifecycle = "2.4.1"
        const val compose = "1.0.5"
    }

    object Application {
        const val code = 6
        const val name = "0.$code"

        fun full(): String {
            return "$name-$code"
        }
    }
}
