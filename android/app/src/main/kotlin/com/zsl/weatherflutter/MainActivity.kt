package com.zsl.weatherflutter

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity() : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //透明状态栏
        getWindow().setStatusBarColor(0x00000000);

        GeneratedPluginRegistrant.registerWith(this)
    }
}
