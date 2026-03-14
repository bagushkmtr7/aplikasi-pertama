allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = layout.buildDirectory.dir("../../build").get().asFile

subprojects {
    project.buildDir = rootProject.buildDir.resolve(project.name)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}

// INI KUNCINYA: Daftarin plugin di sini
plugins {
    id("com.google.gms.google-services") version "4.4.1" apply false
}
