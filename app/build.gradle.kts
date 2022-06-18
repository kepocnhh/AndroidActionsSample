repositories {
    mavenCentral()
    google()
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("org.gradle.jacoco")
    id("io.gitlab.arturbosch.detekt") version Version.detekt
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
            signingConfig = signingConfigs.getByName(name) {
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

fun setCoverage(variant: com.android.build.api.variant.ApplicationVariant) {
    val capitalize = variant.name.capitalize()
    val taskUnitTest = tasks.getByName<Test>("test${capitalize}UnitTest")
    val pack = "org.kepocnhh.aas"
    val taskCoverageReport = task<JacocoReport>("test${capitalize}CoverageReport") {
        dependsOn(taskUnitTest)
        reports {
            csv.required.set(false)
            html.required.set(true)
            xml.required.set(false)
        }
        sourceDirectories.setFrom("$projectDir/src/main/kotlin")
        classDirectories.setFrom(
            fileTree("$buildDir/tmp/kotlin-classes/" + variant.name) {
                include("**/${pack.replace('.', '/')}/implementation/module/**/*")
            }
        )
        executionData(taskUnitTest)
    }
    task<JacocoCoverageVerification>("test${capitalize}CoverageVerification") {
        dependsOn(taskCoverageReport)
        violationRules {
            rule {
                limit {
                    minimum = BigDecimal(0.96)
                }
            }
        }
        classDirectories.setFrom(taskCoverageReport.classDirectories)
        executionData(taskCoverageReport.executionData)
    }
}

fun setQuality(variant: com.android.build.api.variant.ApplicationVariant) {
    val capitalize = variant.name.capitalize()
    val configs = setOf(
        "common",
        "comments",
        "complexity",
        "coroutines",
        "empty-blocks",
        "exceptions",
        "naming",
        "performance",
        "potential-bugs",
        "style"
    ).map { config ->
        File(rootDir, "buildSrc/src/main/resources/detekt/config/$config.yml").existing()
    }
    setOf("main", "test").forEach { source ->
        task<io.gitlab.arturbosch.detekt.Detekt>("verifyCodeQuality$capitalize${source.capitalize()}") {
            jvmTarget = Version.jvmTarget
            setSource(files("src/$source/kotlin"))
            config.setFrom(configs)
            reports {
                xml.required.set(false)
                sarif.required.set(false)
                txt.required.set(false)
                html {
                    required.set(true)
                    outputLocation.set(File(buildDir, "reports/analysis/code/quality/${variant.name}/$source/html/index.html"))
                }
            }
            val postfix = when (source) {
                "main" -> ""
                "test" -> "UnitTest"
                else -> error("Source \"$source\" is not supported!")
            }
            val detektTask = tasks.getByName<io.gitlab.arturbosch.detekt.Detekt>("detekt$capitalize$postfix")
            classpath.setFrom(detektTask.classpath)
        }
    }
}

androidComponents.onVariants { variant ->
    val output = variant.outputs.single()
    check(output is com.android.build.api.variant.impl.VariantOutputImpl)
    output.outputFileName.set("${Repository.name}-${Version.Application.name}-${Version.Application.code}-${variant.buildType!!}.apk")
    afterEvaluate {
        setCoverage(variant)
        setQuality(variant)
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

jacoco {
    toolVersion = Version.jacoco
}

dependencies {
    implementation("androidx.activity:activity-compose:1.4.0")
    implementation("androidx.appcompat:appcompat:1.4.2")
    implementation("androidx.compose.foundation:foundation:${Version.Android.compose}")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:${Version.Android.lifecycle}")
    testImplementation("junit:junit:4.13.2")
}
