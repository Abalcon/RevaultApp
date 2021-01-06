import UIKit
import Flutter
import SwiftyBootpay

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    Bootpay.sharedInstance.appLaunch(application_id: "1544702898")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    Bootpay.sharedInstance.sessionActive(active: false)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    Bootpay.sharedInstance.sessionActive(active: true)
  }
}
