// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("kotlin-android")
    // El plugin de Flutter SIEMPRE después de los de Android/Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.aquatechinn.quiz"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Java 11 (evita los warnings de source/target 8 obsoletos)
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.aquatechinn.quiz"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // Configuración de firma para RELEASE
        create("release") {
            // Si el keystore está en android/app/, esta ruta es correcta
            storeFile = file("aquatechinn-release.keystore")
            storePassword = "Desarrollovrar2023"
            keyAlias = "aquatechinn"
            keyPassword = "Desarrollovrar2023"
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }

        getByName("debug") {
            // Debug usa el keystore por defecto
        }
    }
}

flutter {
    source = "../.."
}
