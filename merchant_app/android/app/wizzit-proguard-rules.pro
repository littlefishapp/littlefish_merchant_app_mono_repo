-verbose
-dontobfuscate
-keepattributes Signature
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses


# ==========================================
# General Rules
# ==========================================


-keep class j$.** { *; }
-dontwarn j$.**
-keep class  org.apache.harmony.xnet.provider.jsse.SSLParametersImpl.** {*;}
-keep class  org.bouncycastle.jsse.BCSSLParameters.** {*;}
-keep class  org.bouncycastle.jsse.BCSSLSocket.** {*;}
-keep class  org.bouncycastle.jsse.provider.BouncyCastleJsseProvider.** {*;}
-keep class  org.joda.time.Instant.** {*;}
-keep class  org.openjsse.javax.net.ssl.SSLParameters.** {*;}
-keep class  org.openjsse.javax.net.ssl.SSLSocket.** {*;}
-keep class  org.openjsse.net.ssl.OpenJSSE.** {*;}
-dontwarn org.apache.harmony.xnet.provider.jsse.SSLParametersImpl
-dontwarn org.bouncycastle.jsse.BCSSLParameters
-dontwarn org.bouncycastle.jsse.BCSSLSocket
-dontwarn org.bouncycastle.jsse.provider.BouncyCastleJsseProvider
-dontwarn org.joda.time.Instant
-dontwarn org.openjsse.javax.net.ssl.SSLParameters
-dontwarn org.openjsse.javax.net.ssl.SSLSocket
-dontwarn org.openjsse.net.ssl.OpenJSSE
-keep class kotlin.** { *; }
-keep class io.flutter.embedding.engine.FlutterJNI {
    *;
}
-keep class org.xmlpull.v1.** { *; }
-dontwarn org.xmlpull.v1.**
-keep class io.flutter.embedding.** {*;}
-printconfiguration ~/tmp/full-r8-config.txt


# ==========================================
# Java Rules
# ==========================================


-keep class  javax.naming.Binding.** {*;}
-keep class  javax.naming.NamingEnumeration.** {*;}
-keep class  javax.naming.NamingException.** {*;}
-keep class  javax.naming.directory.Attribute.** {*;}
-keep class  javax.naming.directory.Attributes.** {*;}
-keep class  javax.naming.directory.DirContext.** {*;}
-keep class  javax.naming.directory.InitialDirContext.** {*;}
-keep class  javax.naming.directory.SearchControls.** {*;}
-keep class  javax.naming.directory.SearchResult.** {*;}
-dontwarn javax.naming.Binding
-dontwarn javax.naming.NamingEnumeration
-dontwarn javax.naming.NamingException
-dontwarn javax.naming.directory.Attribute
-dontwarn javax.naming.directory.Attributes
-dontwarn javax.naming.directory.DirContext
-dontwarn javax.naming.directory.InitialDirContext
-dontwarn javax.naming.directory.SearchControls
-dontwarn javax.naming.directory.SearchResult
-keep public class * implements java.lang.reflect.Type


# ==========================================
# Android Rules
# ==========================================


-keep class androidx.appcompat.graphics.drawable.DrawableWrapper
-keep class androidx.window.extensions.WindowExtensions { *; }
-keep class androidx.window.extensions.WindowExtensionsProvider { *; }
-keep class androidx.window.extensions.area.ExtensionWindowAreaPresentation { *; }
-keep class androidx.window.extensions.layout.DisplayFeature { *; }
-keep class androidx.window.extensions.layout.FoldingFeature { *; }
-keep class androidx.window.extensions.layout.WindowLayoutComponent { *; }
-keep class androidx.window.extensions.layout.WindowLayoutInfo { *; }
-keep class androidx.window.sidecar.SidecarDeviceState { *; }
-keep class androidx.window.sidecar.SidecarDisplayFeature { *; }
-keep class androidx.window.sidecar.SidecarInterface$SidecarCallback { *; }
-keep class androidx.window.sidecar.SidecarInterface { *; }
-keep class androidx.window.sidecar.SidecarProvider { *; }
-keep class androidx.window.sidecar.SidecarWindowLayoutInfo { *; }
-keep class com.android.org.conscrypt.SSLParametersImpl { *; }
-dontwarn androidx.window.extensions.WindowExtensions
-dontwarn androidx.window.extensions.WindowExtensionsProvider
-dontwarn androidx.window.extensions.area.ExtensionWindowAreaPresentation
-dontwarn androidx.window.extensions.layout.DisplayFeature
-dontwarn androidx.window.extensions.layout.FoldingFeature
-dontwarn androidx.window.extensions.layout.WindowLayoutComponent
-dontwarn androidx.window.extensions.layout.WindowLayoutInfo
-dontwarn androidx.window.sidecar.SidecarDeviceState
-dontwarn androidx.window.sidecar.SidecarDisplayFeature
-dontwarn androidx.window.sidecar.SidecarInterface$SidecarCallback
-dontwarn androidx.window.sidecar.SidecarInterface
-dontwarn androidx.window.sidecar.SidecarProvider
-dontwarn androidx.window.sidecar.SidecarWindowLayoutInfo
-dontwarn com.android.org.conscrypt.SSLParametersImpl
-keep class androidx.appcompat.graphics.drawable.DrawableWrapper
-dontwarn androidx.appcompat.graphics.drawable.DrawableWrapper
-keep class com.android.org.conscrypt.** { *; }
-dontwarn com.android.org.conscrypt.**
-keep class androidx.webkit.** { *; }
-keep class androidx.lifecycle.** {*;}
-keep class com.loopj.android.** { *; }
-keep interface com.loopj.android.** { *; }
-keep class androidx.datastore.core.MultiProcessDataStoreFactory { *; }


# ==========================================
# Google Services Rules
# ==========================================


-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication
-keep class com.google.android.play.core.splitinstall.SplitInstallException
-keep class com.google.android.play.core.splitinstall.SplitInstallManager
-keep class com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest
-keep class com.google.android.play.core.splitinstall.SplitInstallSessionState
-keep class com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-keep class com.google.android.play.core.tasks.OnFailureListener
-keep class com.google.android.play.core.tasks.OnSuccessListener
-keep class com.google.android.play.core.tasks.Task
-keep class com.google.crypto.tink.** { *; }
-keep class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken
-keep class com.google.api.client.http.** { *; }
-dontwarn com.google.api.client.http.**
-keep class com.google.crypto.** {*;}
-dontwarn com.google.crypto.** 
-keep class com.google.android.gms.dynamite.zzb { *; }
-keep class com.google.** { *; }
-keep class com.google.android.play.core.** {*;}
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken
-keep class com.google.android.gms.dynamite.zzb { *; }
-keepclassmembers class com.google.android.gms.dynamite.zzb {
    <clinit>();
}
-keep class com.google.android.datatransport.runtime.TransportRuntime { *; }
-keepclassmembers class com.google.android.datatransport.runtime.TransportRuntime {
    <clinit>();
}

-keep class com.google.firebase.** {*;}
-keep class androidx.datastore.core.MultiProcessDataStoreFactory { *; }


# ==========================================
# Wizzit Rules
# ==========================================


-keep class za.co.wizzit.emv.wizzit_emv.** { *; }
-keep class za.co.wizzit.emv.wizzit_emv.model.** { *; }
-keep class com.d.b.** {*;}
-keep class com.e.b.** { *; }
-keep class com.e.** {*;}
-keep class com.a.e.** {*;}
-keep class bbbb.cccc.** {*; }
-keep class com.b.a.** { *; } # THIS NEEDS TO BE LOOKED
-keep class com.aaaa.dddd.** { *; } # THIS NEED TO BE LOOKED
-keep class com.eeee.bbbb.** { *; } # THIS NEED TO BE LOOKED
-keep class com.cccc.cccc.** { *; } # THIS NEED TO BE LOOKED
-keep class come.eeee.cccc.** {*;}
-keep class com.c.c.** {*;}
-keep class org.bouncycastle.** { *; }
-keep class com.cccc.cccc.bbbb.** { *; } # THIS NEED TO BE LOOKED
-keep class com.wizzitdigital.emv.** { *; }
-keep class com.mastercard.terminalsdk.** { *; }
-keep class com.wizzitdigital.emv.sdk.mastercard.** { *; }
-keep class com.wizzitdigital.emv.sdk.mastercard.internal.** { *; }
-keep class com.wizzitdigital.emv.sdk.internal.values.** { *; }
-keep class com.mastercard.terminalsdk.internal.** {*;}
-keep class com.b.c.** {*;}
-keep class bbbb.cccc.** {*;}
-keep class com.eeee.** {*;}