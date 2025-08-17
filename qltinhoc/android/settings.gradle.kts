pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().buffered().use(properties::load)
        properties.getProperty("flutter.sdk")
            ?: throw IllegalStateException("flutter.sdk not set in local.properties")
    }
    includeBuild(File(flutterSdkPath, "packages/flutter_tools/gradle"))

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
    id("com.android.application") version "8.2.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.20" apply false
}

include(":app")