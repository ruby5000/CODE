import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import Firebase
import FBSDKCoreKit
import UserNotifications
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = GoogleClient_Id
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
        
        func startAuth(phoneNumber: String,smsCode:String) {
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
              verificationCode: smsCode
            )
            PhoneAuthProvider.provider()
              .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                  if error != nil {
                    return
                  }
              }
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
    
    func application(_ application: UIApplication,
        didReceiveRemoteNotification notification: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      if Auth.auth().canHandleNotification(notification) {
        completionHandler(.noData)
        return
      }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var flag: Bool = false
        if ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]) {
            //Facebook
            flag = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        } else {
            //Google
            flag = GIDSignIn.sharedInstance().handle(url)
        }
        if Auth.auth().canHandle(url) {
          return true
        }
        return flag
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
}
