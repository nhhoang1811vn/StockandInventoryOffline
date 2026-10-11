package com.ssteam.goodmanagerflutter

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Android 15+ ignores statusBarColor. With the edge-to-edge opt-out,
        // the system keeps an opaque black status bar while Flutter asks for
        // dark icons on the light theme, so the clock and battery disappear.
        // Draw Flutter behind the bar; the scaffold color becomes the bar
        // background and the existing icon brightness stays readable.
        WindowCompat.setDecorFitsSystemWindows(window, false)
        if (Build.VERSION.SDK_INT >= 35) {
            window.statusBarColor = Color.TRANSPARENT
            window.navigationBarColor = Color.TRANSPARENT
        }
        UCropInsetsFix.register(application)
    }
}
