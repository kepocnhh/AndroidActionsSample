buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath(Dependency.Android.ToolsBuildGradle.notation())
    }
}

task<Delete>("clean") {
    delete = setOf(buildDir, "buildSrc/build")
}
