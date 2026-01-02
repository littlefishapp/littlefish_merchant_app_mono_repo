package com.littlefish_merchant_app

import io.flutter.embedding.android.FlutterActivity
import com.google.firebase.crashlytics.FirebaseCrashlytics
import android.util.Log
import android.os.Bundle

class MainActivity: FlutterActivity() {
     override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("MainActivity", "#### onCreate called")

        FirebaseCrashlytics.getInstance().apply {
            setCrashlyticsCollectionEnabled(true)
        }

        Thread.setDefaultUncaughtExceptionHandler { _, throwable ->
            FirebaseCrashlytics.getInstance().recordException(throwable)
        }
    } 
}
