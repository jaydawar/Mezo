import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyC-jkkd-A9v4OHffm2K9Oa1JVFUYl5C3Go")
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "mezo.app.open",
    binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
    (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

    if call.method == "openUber" {
    result(FlutterMethodNotImplemented)
    self.openUberApp()
    }
    if call.method == "openLyft" {
    result(FlutterMethodNotImplemented)
    self.openLyftApp()
    }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


  func openUberApp(){
  let uberURL = URL(string: "uber://")
    let appStoreURL = URL(string: "itms-apps://itunes.apple.com/us/app/uber/id368677368?mt=8")

    if let uberURL = uberURL {
        if UIApplication.shared.canOpenURL(uberURL) {
            UIApplication.shared.openURL(uberURL)
        } else {
            if let appStoreURL = appStoreURL {
                UIApplication.shared.openURL(appStoreURL)
            }
        }
    }
  }

 func openLyftApp(){
  let uberURL = URL(string: "lyft://")
      let appStoreURL = URL(string: "itms-apps://itunes.apple.com/us/app/lyft/id529379082?mt=8")

      if let uberURL = uberURL {
          if UIApplication.shared.canOpenURL(uberURL) {
              UIApplication.shared.openURL(uberURL)
          } else {
              if let appStoreURL = appStoreURL {
                  UIApplication.shared.openURL(appStoreURL)
              }
          }
      }
   }

  func lyftInstalled() -> Bool {
    return UIApplication.shared.canOpenURL(URL(string: "lyft://")!)
  }

  func open(scheme: String) {
    if let url = URL(string: scheme) {
      if #available(iOS 10, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }
}
