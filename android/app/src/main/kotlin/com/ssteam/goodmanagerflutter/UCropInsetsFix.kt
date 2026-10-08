package com.ssteam.goodmanagerflutter

import android.app.Activity
import android.app.Application
import android.os.Build
import android.os.Bundle
import android.view.View
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

object UCropInsetsFix : Application.ActivityLifecycleCallbacks {
    private const val UCROP_ACTIVITY = "com.yalantis.ucrop.UCropActivity"
    private var registered = false

    fun register(application: Application) {
        if (registered || Build.VERSION.SDK_INT < 35) return
        registered = true
        application.registerActivityLifecycleCallbacks(this)
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        if (activity.javaClass.name != UCROP_ACTIVITY) return
        val content = activity.findViewById<View>(android.R.id.content) ?: return
        ViewCompat.setOnApplyWindowInsetsListener(content) { view, insets ->
            val nav = insets.getInsets(WindowInsetsCompat.Type.navigationBars())
            val status = insets.getInsets(WindowInsetsCompat.Type.statusBars())
            val top = if (Build.VERSION.SDK_INT >= 36) status.top else 0
            view.setPadding(nav.left, top, nav.right, nav.bottom)
            insets
        }
        ViewCompat.requestApplyInsets(content)
    }

    override fun onActivityStarted(activity: Activity) {}
    override fun onActivityResumed(activity: Activity) {}
    override fun onActivityPaused(activity: Activity) {}
    override fun onActivityStopped(activity: Activity) {}
    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}
    override fun onActivityDestroyed(activity: Activity) {}
}
