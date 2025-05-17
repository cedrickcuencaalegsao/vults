plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    ndkVersion = "27.0.12077973"
    namespace = "com.example.vults"
    compileSdk = flutter.compileSdkVersion.toInt()

    defaultConfig {
        applicationId = "com.example.vults"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion.toInt()
        versionCode = flutter.versionCode.toInt()
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true // ✅ Kotlin DSL syntax
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") // ✅ upgraded version

    implementation("androidx.core:core-ktx:1.10.1")
    implementation("com.google.firebase:firebase-messaging:23.0.0")
    implementation("com.google.firebase:firebase-auth-ktx:22.1.2")
    implementation("com.google.firebase:firebase-firestore-ktx:24.10.2")
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.8.0")
}

flutter {
    source = "../.."
}
