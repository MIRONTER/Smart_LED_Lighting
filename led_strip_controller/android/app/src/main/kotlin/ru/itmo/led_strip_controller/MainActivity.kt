package ru.itmo.led_strip_controller

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        getIntent().putExtra("enable-software-rendering", true)
        super.onCreate(savedInstanceState)
    }
}