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

    buildFeatures {
        compose = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = Version.Android.compose
    }
}

androidComponents.onVariants { variant ->
    val output = variant.outputs.single()
    check(output is com.android.build.api.variant.impl.VariantOutputImpl)
    output.outputFileName.set("${Repository.name}-${output.versionCode.get()}-${variant.buildType!!}.apk")
    afterEvaluate {
        tasks.getByName<JavaCompile>("compile${variant.name.capitalize()}JavaWithJavac") {
            targetCompatibility = Version.jvmTarget
        }
        tasks.getByName<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>("compile${variant.name.capitalize()}Kotlin") {
            kotlinOptions.jvmTarget = Version.jvmTarget
        }
        val checkManifestTask = task("checkManifest${variant.name.capitalize()}") {
            dependsOn("compile${variant.name.capitalize()}Sources")
            doLast {
                val file = "intermediates/merged_manifest/${variant.name}/AndroidManifest.xml"
                val manifest = groovy.xml.XmlParser().parse(File(buildDir, file))
                val actual = manifest.getAt(groovy.namespace.QName("uses-permission")).map {
                    check(it is groovy.util.Node)
                    val attributes = it.attributes().mapKeys { (k, _) -> k.toString() }
                    val name = attributes["{http://schemas.android.com/apk/res/android}name"]
                    check(name is String && name.isNotEmpty())
                    name
                }
                val expected = emptySet<String>()
                check(actual.sorted() == expected.sorted()) {
                    "Actual is:\n${actual.joinToString(separator = "\n")}\nbut expected is:\n${expected.joinToString(separator = "\n")}"
                }
            }
        }
        tasks.getByName("assemble${variant.name.capitalize()}").dependsOn(checkManifestTask)
    }
}

dependencies {
    implementation("androidx.activity:activity-compose:1.4.0")
    implementation("androidx.appcompat:appcompat:1.4.2")
    implementation("androidx.compose.foundation:foundation:${Version.Android.compose}")
//    implementation("androidx.lifecycle:lifecycle-viewmodel:${Version.Android.lifecycle}")
//    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:${Version.Android.lifecycle}")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:${Version.Android.lifecycle}")
}
