# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Sign-In
-keep class com.google.android.gms.auth.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# Play Core Library
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.** { *; }

# Gson
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepattributes Exceptions

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.firebase.** { *; }

# Razorpay
-keep class com.razorpay.** { *; }
-keepclassmembers class * implements androidx.viewbinding.ViewBinding {
    public static ** bind(android.view.View);
}
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepclassmembers class com.razorpay.** {
    *;
}
-dontwarn com.razorpay.**
-keep class proguard.annotation.** { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }
-keep class com.google.android.gms.location.** { *; }

# Keep your model classes
-keep class com.youpackage.**.model.** { *; }

# Keep kotlin metadata
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes RuntimeInvisibleParameterAnnotations
-keepattributes AnnotationDefault

# Keep generic signatures and annotations
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes EnclosingMethod
