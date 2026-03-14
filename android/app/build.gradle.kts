plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.aplikasi_pertama"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.aplikasi_pertama"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        getByName("release") {
            // Kita matikan dua-duanya biar nggak protes lagi si Gradle
            isMinifyEnabled = false
            isShrinkResources = false 
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
