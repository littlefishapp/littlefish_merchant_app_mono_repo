package com.example.littlefish_pos_ui

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if ("paydroid.intent.action.BOOT_COMPLETED" == intent.action) {
            Log.d("BootReceiver", "#### Boot broadcast received, enqueuing work")
            val workRequest = OneTimeWorkRequestBuilder<BootLaunchWorker>().build()
            WorkManager.getInstance(context).enqueue(workRequest)
        }
    }
}