# Android Build Configuration Guide

This document explains the key Android build configurations used in our Flutter project's Android build files. Examples are provided for both Kotlin DSL (`build.gradle.kts`) and Groovy (`build.gradle`) formats.

## 📱 Android SDK Configuration

### Compile SDK Version

**Kotlin DSL (`build.gradle.kts`)**:

```kotlin
compileSdkVersion flutter.compileSdkVersion
```

**Groovy (`build.gradle`)**:

```groovy
compileSdkVersion flutter.compileSdkVersion
```

**Purpose**: Defines the Android SDK version used during compilation

- Determines which Android APIs are available during the build process
- Using Flutter's managed version ensures compatibility with Flutter framework
- Does not affect runtime behavior, only compilation

### NDK Version

**Kotlin DSL (`build.gradle.kts`)**:

```kotlin
ndkVersion flutter.ndkVersion
```

**Groovy (`build.gradle`)**:

```groovy
ndkVersion flutter.ndkVersion
```

**Purpose**: Specifies the Android Native Development Kit version

- Required for building Flutter's native engine components
- Handles native C/C++ code compilation
- Flutter manages this version to ensure engine compatibility

## ☕ Java Compatibility Settings

### Compile Options

**Kotlin DSL (`build.gradle.kts`)**:

```kotlin
compileOptions {
    coreLibraryDesugaringEnabled = true
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}
```

**Groovy (`build.gradle`)**:

```groovy
compileOptions {
    coreLibraryDesugaringEnabled true
    sourceCompatibility JavaVersion.VERSION_17
    targetCompatibility JavaVersion.VERSION_17
}
```

#### Core Library Desugaring

- **What it does**: Enables newer Java APIs on older Android versions
- **Benefit**: Modern Java features work on devices with older Android APIs
- **Example**: Allows `java.time` APIs on Android versions that don't natively support them

#### Source Compatibility

- **What it controls**: Java language features available in source code
- **Java 17 features**: Pattern matching, records, sealed classes, text blocks
- **Why Java 17**: New Android applications use Java 17 by default

#### Target Compatibility

- **What it controls**: JVM version the compiled bytecode targets
- **Purpose**: Ensures bytecode runs on Java 17+ runtime environments
- **Must match**: Source compatibility version for consistency

## 🚀 Kotlin Configuration

### JVM Target

**Kotlin DSL (`build.gradle.kts`)**:

```kotlin
kotlinOptions {
    jvmTarget = JavaVersion.VERSION_17.toString()
}
```

**Groovy (`build.gradle`)**:

```groovy
kotlinOptions {
    jvmTarget = JavaVersion.VERSION_17
}
```

**Purpose**: Sets Kotlin compiler's JVM target

- **Critical**: Must match Java `targetCompatibility` setting
- **Why**: Ensures Kotlin and Java code compile to the same bytecode version
- **Result**: Prevents compatibility issues between Kotlin and Java components
- **Note**: Kotlin DSL requires `.toString()` while Groovy accepts the enum directly

## 🔧 Complete Configuration Example

### Kotlin DSL (`app/build.gradle.kts`)

```kotlin
android {
    // Android SDK version used for compilation - determines available APIs during build
    compileSdkVersion flutter.compileSdkVersion

    // NDK version for building native C/C++ code - required for Flutter's native engine
    ndkVersion flutter.ndkVersion

    // buildToolsVersion flutter.buildToolsVersion

    compileOptions {
        // Enables newer Java APIs on older Android versions through desugaring
        coreLibraryDesugaringEnabled = true

        // Java source code compatibility - what Java language features can be used in source code
        // VERSION_17 allows modern Java syntax like pattern matching, records, etc.
        // Why Java 17: because new Android applications are built with this by default
        sourceCompatibility = JavaVersion.VERSION_17

        // Java bytecode target - what JVM version the compiled bytecode targets
        // VERSION_17 ensures bytecode runs on Java 17+ runtime environments
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        // Kotlin compiler JVM target - must match targetCompatibility above
        // Ensures Kotlin and Java code compile to same bytecode version for compatibility
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
}
```

### Groovy (`app/build.gradle`)

```groovy
android {
    // Android SDK version used for compilation - determines available APIs during build
    compileSdkVersion flutter.compileSdkVersion

    // NDK version for building native C/C++ code - required for Flutter's native engine
    ndkVersion flutter.ndkVersion

    // buildToolsVersion flutter.buildToolsVersion

    compileOptions {
        // Enables newer Java APIs on older Android versions through desugaring
        coreLibraryDesugaringEnabled true

        // Java source code compatibility - what Java language features can be used in source code
        // VERSION_17 allows modern Java syntax like pattern matching, records, etc.
        // Why Java 17: because new Android applications are built with this by default
        sourceCompatibility JavaVersion.VERSION_17

        // Java bytecode target - what JVM version the compiled bytecode targets
        // VERSION_17 ensures bytecode runs on Java 17+ runtime environments
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        // Kotlin compiler JVM target - must match targetCompatibility above
        // Ensures Kotlin and Java code compile to same bytecode version for compatibility
        jvmTarget JavaVersion.VERSION_17
    }
}
```

### Key Syntax Differences

- **Assignment operators**: Kotlin DSL uses `=` while Groovy uses space
- **JavaVersion handling**: Kotlin DSL requires `.toString()` for jvmTarget, Groovy accepts enum directly
- **Boolean values**: Both support `true/false` but Kotlin DSL is more strict about types

## 🔄 Upgrade Guidelines

- ✅ `compileSdkVersion flutter.compileSdkVersion` - Flutter manages compatibility
- ✅ `ndkVersion flutter.ndkVersion` - Tested by Flutter team
- ❗️ You can manage both compileSdkVersion and ndkVersions yourself, instead of having flutter changing your versions on each upgrades.

### Upgrade with Caution

- ⚠️ **Java versions** - Only upgrade when Flutter stable releases officially support newer versions
- ⚠️ **Always test** - Verify build pipeline works after any Java version changes

### Best Practices

1. Let Flutter manage SDK/NDK versions by using their constants
2. Keep Java compatibility settings conservative
3. Test thoroughly after any compatibility upgrades
4. Follow Flutter's official migration guides

## 🛠️ Troubleshooting

If you encounter build errors after upgrades:

1. Run `flutter doctor -v` to check Java version compatibility
2. Use `flutter analyze --suggestions` to verify AGP/Java/Gradle compatibility
3. Ensure Gradle version supports your Java version (7.3+ for Java 17)

## 📚 Additional Resources

- [Flutter Android Migration Guide](https://docs.flutter.dev/release/breaking-changes/android-java-gradle-migration-guide)
- [Android Gradle Plugin Compatibility](https://developer.android.com/studio/releases/gradle-plugin#updating-gradle)
- [Java Version Compatibility Matrix](https://docs.gradle.org/current/userguide/compatibility.html)

---

_Last updated: [Current Date] | Flutter Version: [Your Flutter Version]_
