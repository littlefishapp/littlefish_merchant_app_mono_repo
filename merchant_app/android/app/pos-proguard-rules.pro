-keep class com.pax.** { *; }
-keep class com.google.** { *; }
-keep class com.jcraft.jsch.** { *; }
-keep class org.dom4j.** { *; }
# ==========================================
# KOTLIN METADATA PRESERVATION - CRITICAL
# ==========================================

# Keep Kotlin metadata class itself
-keep class kotlin.Metadata { *; }
# Keep Kotlin internal classes (critical for metadata)
-keep class kotlin.jvm.internal.** { *; }
-keep class kotlin.coroutines.jvm.internal.** { *; }
-keep class kotlin.reflect.jvm.internal.** { *; }

# ==========================================
# PAX & PAYMENT PROCESSING
# ==========================================

# Keep jcraft jzlib classes
-keep class com.jcraft.jzlib.** { *; }
-dontwarn com.jcraft.jzlib.**

# Keep PAX framework classes
-keep class com.pax.framework.** { *; }
-keep class com.pax.posproto.** { *; }
-dontwarn com.pax.framework.**
-dontwarn com.pax.posproto.**

# ==========================================
# XML & DATA PROCESSING
# ==========================================

# Keep Sun MSV datatype classes
-keep class com.sun.msv.datatype.** { *; }
-dontwarn com.sun.msv.datatype.**

# Keep Java Beans classes
-keep class java.beans.** { *; }
-dontwarn java.beans.**

# Keep Swing classes
-keep class javax.swing.** { *; }
-dontwarn javax.swing.**

# Keep JAXB classes
-keep class javax.xml.bind.** { *; }
-dontwarn javax.xml.bind.**

# Keep XML Stream classes
-keep class javax.xml.stream.** { *; }
-dontwarn javax.xml.stream.**

# Keep Jaxen XPath classes
-keep class org.jaxen.** { *; }
-dontwarn org.jaxen.**

# Keep RelaxNG datatype classes
-keep class org.relaxng.datatype.** { *; }
-dontwarn org.relaxng.datatype.**

# Keep XPP (XML Pull Parser) classes
-keep class org.gjt.xpp.** { *; }
-dontwarn org.gjt.xpp.**

# Keep GSS (Generic Security Services) classes
-keep class org.ietf.jgss.** { *; }
-dontwarn org.ietf.jgss.**

# ==========================================
# ANDROID X
# ==========================================

-keep class androidx.window.** { *; }
-keep class androidx.window.extensions.** { *; }
-keep class androidx.window.sidecar.** { *; }
-keep class androidx.appcompat.** { *; }
-keep class androidx.appcompat.graphics.drawable.DrawableWrapper { *; }
-dontwarn androidx.window.**
-dontwarn androidx.window.extensions.**
-dontwarn androidx.window.sidecar.**
-dontwarn androidx.appcompat.graphics.drawable.DrawableWrapper