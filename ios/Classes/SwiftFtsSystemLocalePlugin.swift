import Flutter
import UIKit

public class SwiftFtsSystemLocalePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "fts_system_locale", binaryMessenger: registrar.messenger())
    let instance = SwiftFtsSystemLocalePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
     if( call.method == "setLocale"){
        let arguments = call.arguments as! Dictionary<String, Any>
        let locale = arguments["locale"] as! String
        let userDefaults = UserDefaults.standard
        userDefaults.set([locale], forKey: "AppleLanguages")
        result(true)
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
}
