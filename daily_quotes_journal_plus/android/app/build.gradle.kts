plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.quotejournal"  // This should match your package name.
    compileSdk = 33  // Manually set the compileSdkVersion to the latest stable version.

    ndkVersion = "29.0.13113456"  // This version should be compatible with your setup.

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.quotejournal"  // The app package name.
        minSdk = 21  // Set minimum SDK version.
        targetSdk = 36  // Set target SDK version.
        versionCode = 1  // Version code.
        versionName = "1.0.0"  // Version name.
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")  // Set the signing config.
        }
    }
}

flutter {
    source = "../.."  // Correct path to the flutter directory.
}
