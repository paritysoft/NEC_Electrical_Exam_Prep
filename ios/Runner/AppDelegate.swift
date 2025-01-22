import Flutter
import AppTrackingTransparency
import UIKit
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      do {
                 FirebaseApp.configure()
             } catch {
                 print("Error configuring Firebase: \(error)")
             }
    GeneratedPluginRegistrant.register(with: self)
     
//      requestTrackingPermission()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func requestTrackingPermission() {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        print("Tracking authorized.")
                        // Tracking is enabled. You can collect the IDFA here if needed:
//                        let idfa = ASIdentifierManager.shared().advertisingIdentifier
//                        print("IDFA: \(idfa)")
                    case .denied:
                        print("Tracking denied.")
                    case .notDetermined:
                        print("Tracking permission not determined.")
                    case .restricted:
                        print("Tracking restricted.")
                    @unknown default:
                        print("Unknown tracking status.")
                    }
                }
            } else {
                print("ATT is not available for iOS versions below 14.")
            }
        }
}
