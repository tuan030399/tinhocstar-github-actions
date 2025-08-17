# Flutter Default Rules
-dontwarn io.flutter.embedding.**
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugins.*.* { *; }

# Google ML Kit and Text Recognition Core Rules
-keep public class com.google.mlkit.** {*;}
-keep public class com.google.android.gms.internal.mlkit_vision_text.** {*;}
-keep public class com.google.android.gms.internal.mlkit_vision_internal.** {*;}
-keep public class com.google.android.gms.internal.mlkit_vision_text_common.** {*;}

# Rules for Flutter plugin
-keep class com.google_mlkit_text_recognition.** {*;}

# Keep all text recognizer options, builders, and language-specific classes explicitly
-keep class com.google.mlkit.vision.text.** { *; }
-keep class * extends com.google.mlkit.vision.text.TextRecognizerOptions { *; }
-keep class * extends com.google.mlkit.vision.text.TextRecognizerOptions$Builder { *; }