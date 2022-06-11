repositories {
    mavenCentral()
    google()
}

plugins {
    id("com.android.application")
    id("kotlin-android")
}

android {
    compileSdk = Version.Android.compileSdk

    defaultConfig {
        minSdk = Version.Android.minSdk
        targetSdk = Version.Android.targetSdk
        versionCode = Version.Application.code
        versionName = Version.Application.name
    }

    buildTypes {
        getByName("debug") {
            applicationIdSuffix = ".$name"
            versionNameSuffix = "-$name"
            isMinifyEnabled = false
            isShrinkResources = false
            manifestPlaceholders["buildType"] = name
            isTestCoverageEnabled = false
            signingConfigs.getByName(name) {
                storeFile = file("src/$name/resources/key.pkcs12").existing()
                storePassword = file("src/$name/resources/properties").existing()
                    .toProperties().requireString("password").filled()
                keyAlias = name
                keyPassword = storePassword
            }
        }
    }
}
