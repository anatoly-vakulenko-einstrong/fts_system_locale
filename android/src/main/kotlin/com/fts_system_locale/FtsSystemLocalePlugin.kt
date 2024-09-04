package com.fts_system_locale

import android.app.Application
import android.app.LocaleManager
import android.os.Build
import android.os.LocaleList
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.getSystemService
import com.yariksoffice.lingver.Lingver
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.Locale

const val channelName = "fts_system_locale"

/** FtsSystemLocalePlugin */
class FtsSystemLocalePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var application: Application

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
        channel.setMethodCallHandler(this)
        application = flutterPluginBinding.applicationContext as Application
        if (Build.VERSION.SDK_INT < 33) {
            Lingver.init(application, Locale.getDefault())
        }
    }

    private fun setAppLocale(locale: String?) {
        if (locale == null) {
            if (Build.VERSION.SDK_INT >= 33) {
                val localeManager = getSystemService(application, LocaleManager::class.java)
                localeManager?.applicationLocales = localeManager!!.systemLocales

            }else {
                Lingver.getInstance().setFollowSystemLocale(application)
            }
            Log.d(channelName, "Locale set to system default")
        } else {
            if (Build.VERSION.SDK_INT >= 33) {
                val localeList = LocaleList(Locale(locale))
                val localeManager = getSystemService(application, LocaleManager::class.java)
                localeManager?.applicationLocales = localeList
            }else{
                Lingver.getInstance().setLocale(application, locale)
            }
            Log.d(channelName, "Locale set to $locale")
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "setLocale" -> {
                val locale = call.argument<String>("locale")
                setAppLocale(locale)
                result.success(true)
            }
            else -> result.notImplemented()
        }

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
