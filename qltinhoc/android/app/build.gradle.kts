import org.gradle.api.JavaVersion // Thêm import này

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

fun localProperties(): java.util.Properties {
    val properties = java.util.Properties()
    rootProject.file("local.properties").takeIf { it.exists() }?.inputStream()?.use { properties.load(it) }
    return properties
}

val flutterVersionCode: String? by localProperties()
val flutterVersionName: String? by localProperties()

android {
    namespace = "com.example.qltinhoc"
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "com.example.qltinhoc"
        minSdk = 21
        targetSdk = 34
        versionCode = (flutterVersionCode ?: "1").toInt()
        versionName = flutterVersionName ?: "1.0"
    }
    
    signingConfigs {
        getByName("debug")
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {}