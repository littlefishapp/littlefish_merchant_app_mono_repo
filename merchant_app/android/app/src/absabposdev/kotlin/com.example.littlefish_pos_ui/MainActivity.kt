package com.example.littlefish_pos_ui

import android.content.Intent
import android.os.Bundle
// 
/*  
NOTE: WHEN IT IS BPOS_LAUNCH YOU DO NOT NEED THIS BECAUSE PACKAGE NAME IS THE SAME 
IN MAIN ANDROIDMANIFEST BUT FOR BPOS YOU NEED IT BECAUSE THE PACKAGE NAME IN ANDROIDMANIFEST IS LITTLEFISH_MERCHANT_APP

Kotlin is stricter about requiring explicit imports for classes outside the current package
*/ 
// import com.littlefish_merchant_app.BuildConfig // Kotlin does not know where to find this 
import io.flutter.embedding.android.FlutterActivity
import com.google.firebase.crashlytics.FirebaseCrashlytics
import android.util.Log
import com.pax.poslink.peripheries.MiscSettings

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        Log.d("MainActivity", "#### onCreate called")
        
        Log.d("MainActivity", "#### BuildConfig.posIsKiosk: ${BuildConfig.isKiosk}")
        
        val disableKeys = BuildConfig.isKiosk
        if (disableKeys) {
          MiscSettings.setHomeKeyEnable(this, false);
          MiscSettings.setRecentKeyEnable(this, false);
          Log.d("MainActivity", "#### Home and Recent keys disabled");
        } else {
          MiscSettings.setHomeKeyEnable(this, true);
          MiscSettings.setRecentKeyEnable(this, true);
          Log.d("MainActivity", "#### Home and Recent keys enabled");
        }


        FirebaseCrashlytics.getInstance().apply {
            setCrashlyticsCollectionEnabled(true)
        }

        Thread.setDefaultUncaughtExceptionHandler { _, throwable ->
            FirebaseCrashlytics.getInstance().recordException(throwable)
        }
    }    
  
}
