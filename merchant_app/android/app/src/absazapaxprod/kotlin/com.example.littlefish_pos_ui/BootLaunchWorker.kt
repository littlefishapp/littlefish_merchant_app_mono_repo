package com.example.littlefish_pos_ui

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters


class BootLaunchWorker(context: Context, params: WorkerParameters) : Worker(context, params) {

    override fun doWork(): Result {
        return try {
            Log.d("BootLaunchWorker", "#### Starte 50s delay")
            Thread.sleep(50000)
            Log.d("BootLaunchWorker", "#### Delay complete")
            // Attempt to launch MainActivity
            val intent = Intent(applicationContext, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            applicationContext.startActivity(intent)
            Log.d("BootLaunchWorker", "#### startActivity() called ")

            Result.success()
        } catch (e: Exception) {
            Log.e("BootLaunchWorker", "##### Error launching activity", e)
            Result.failure()
        }
    }
}