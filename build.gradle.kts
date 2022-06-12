buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:${Version.Android.toolsBuildGradle}")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:${Version.kotlin}")
    }
}

task<Delete>("clean") {
    delete = setOf(buildDir, "buildSrc/build")
}

repositories.mavenCentral() // com.pinterest.ktlint

val kotlinLint: Configuration by configurations.creating

dependencies {
    kotlinLint("com.pinterest:ktlint:${Version.ktlint}") {
        attributes {
            attribute(Bundling.BUNDLING_ATTRIBUTE, objects.named(Bundling.EXTERNAL))
        }
    }
}

task<JavaExec>("verifyCodeStyle") {
    classpath = kotlinLint
    mainClass.set("com.pinterest.ktlint.Main")
    args(
        "build.gradle.kts",
        "settings.gradle.kts",
        "buildSrc/src/main/kotlin/**/*.kt",
        "buildSrc/build.gradle.kts",
        "app/src/main/kotlin/**/*.kt",
        "app/src/test/kotlin/**/*.kt",
        "app/build.gradle.kts",
        "--reporter=html,output=${File(buildDir, "reports/analysis/code/style/html/index.html")}"
    )
}

task("verifyReadme") {
    doLast {
        val badges = setOf(
            MarkdownUtil.image(
                text = "version",
                url = BadgeUtil.url(
                    label = "version",
                    message = Version.Application.full(),
                    color = "2962ff"
                )
            )
        )
        FileUtil.check(
            file = File(rootDir, "README.md"),
            expected = badges,
            report = File(buildDir, "reports/analysis/readme/index.html")
        )
    }
}

task("verifyLicense") {
    doLast {
        FileUtil.check(
            file = File(rootDir, "LICENSE"),
            expected = emptySet(),
            report = File(buildDir, "reports/analysis/license/index.html")
        )
    }
}

task("verifyService") {
    doLast {
        val forbidden = setOf(".DS_Store")
        rootDir.forEachRecurse {
            if (!it.isDirectory) check(!forbidden.contains(it.name)) {
                "File by path ${it.absolutePath} is forbidden!"
            }
        }
    }
}

task("saveCommonInfo") {
    doLast {
        val result = org.json.JSONObject(
            mapOf(
                "version" to mapOf(
                    "code" to Version.Application.code,
                    "name" to Version.Application.name
                ),
                "repository" to mapOf(
                    "owner" to Repository.owner,
                    "name" to Repository.name
                )
            )
        ).toString()
        File(buildDir, "common.json").also {
            it.parentFile!!.mkdirs()
            it.delete()
            it.writeText(result)
        }
    }
}
