# --- PAX SDK and related libraries ---
-keep class com.pax.** { *; }
-keep class eft.** { *; }
-keep class com.littlefishpay.** { *; }
-keep class com.littlefishapp.** { *; }
-keep class com.pax.dal.** { *; }
-keep class com.pax.neptunelite.** { *; }
-keep class com.pax.neptunelite.api.** { *; }
-keep class com.pax.dal.entity.** { *; }
-keep class com.pax.dal.exceptions.** { *; }
-keep class com.pax.dal.impl.** { *; }
-keep class com.pax.daemon.** { *; }
-keep class com.pax.** { *; }
-keep class com.pax.** { public protected *; }

-dontwarn com.pax.neptunelite.api.NeptuneLiteUser
-keep class com.pax.neptunelite.api.NeptuneLiteUser{
    public static synchronized com.pax.neptunelite.api.NeptuneLiteUser getInstance();
    public synchronized com.pax.dal.IDAL getDal(android.content.Context);
    private com.pax.dal.IDAL loadDalDex(android.content.Context, java.lang.String);
}
-keep class com.pax.neptunelite.api.Nepcore{*;}
-keep interface com.pax.dal.IDAL{
    com.pax.dal.ISys getSys();
    com.pax.dal.IPrinter getPrinter();
    com.pax.dal.IPed getPed(com.pax.dal.entity.EPedType );
}
-keep interface com.pax.dal.IPrinter{
    int start();
    void init();
    void setGray(int);
    void spaceSet(byte , byte );
    void printStr(java.lang.String , java.lang.String);
    void step(int) ;
}
-keep interface com.pax.dal.IPed{  com.pax.dal.entity.KeyInfo queryKeyInfo(byte, byte); }
-keep interface com.pax.dal.ISys{*;}
-keep interface com.pax.dal.proxy.IDALProxy{ *; }
-keep class com.pax.dal.entity.EPedType{ *; }
-keep class com.pax.dal.entity.ETermInfoKey{ *; }
-keep class com.pax.dal.entity.KeyInfo{ *; }
-keep class com.pax.dal.exceptions.PrinterDevException{ *; }
-keep class com.pax.dal.exceptions.PedDevException{ *; }
-keep class com.pax.dal.exceptions.EPedDevException{ *; }

# --- Common libraries used by PAX and Android ---
-keep class com.google.** { *; }
-keep class com.jcraft.jsch.** { *; }
-keep class org.dom4j.** { *; }
-keep class org.bouncycastle.** { *; }
-keep class org.apache.** { *; }
-keep class org.json.** { *; }
-keep class org.xmlpull.** { *; }
-keep class com.zxing.** { *; }

# --- Reflection and JNI ---
-keepclassmembers class * {
    native <methods>;
}
-keepclasseswithmembernames class * {
    native <methods>;
}
-keepclassmembers class * {
    public <init>(...);
}
-keepclassmembers class * {
    public *;
}

# --- Serialization ---
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# --- Android specific ---
-keep class * extends android.app.Activity
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver
-keep class * extends android.content.ContentProvider
-keep class * extends android.app.Application

# --- Flutter plugin reflection ---
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.engine.plugins.** { *; }
-keep class io.flutter.plugin.common.** { *; }

# --- Prevent removal of classes used in manifest ---
-keepnames class * {
    public <init>(...);
}
-keepclassmembers class * {
    public <init>(android.content.Context, ...);
}

# --- Keep enums ---
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}