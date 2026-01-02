package com.littlefish_merchant_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class ForegroundReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        // Check if we received the correct action
        if (intent?.action == "com.littlefish.action.BRING_TO_FOREGROUND") {
            Log.d("ForegroundReceiver", "#### Received broadcast to bring app to foreground")

            // Create an intent to launch the MainActivity
            val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)

            // Safely handle the case where the intent might be null
            launchIntent?.let {
                // Use the 'or' keyword for bitwise operations in Kotlin
                it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
                context.startActivity(it)
            }
        }
    }
}