package com.example.littlefish_pos_ui

import android.content.Intent
import android.os.Bundle
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
