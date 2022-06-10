buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

task<Delete>("clean") {
    delete = setOf(buildDir)
}
