# Keep all TensorFlow Lite classes
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }

# Prevent R8 from stripping TensorFlow Lite GPU delegate
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate$Options { *; }

# Keep JNI (native) methods
-keepclassmembers class * {
    native <methods>;
}
