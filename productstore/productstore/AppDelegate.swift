
import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit
import FirebaseMessaging
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    IQKeyboardManager.shared.enable = true
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    setDecimalNumber()
    UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:] , key: UD_CouponObj)
    UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:] , key: UD_BillingObj)
    if UserDefaults.standard.value(forKey: UD_GuestObj) == nil
    {
      let Guestcart_Array = [[String:String]]()
      UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: Guestcart_Array, key: UD_GuestObj)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    }
    else {
      UNUserNotificationCenter.current().delegate = self
      let settings: UIUserNotificationSettings =
      UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }

    application.registerForRemoteNotifications()
    FirebaseApp.configure()
    FirebaseApp.debugDescription()
    Messaging.messaging().delegate = self
    return true
  }

  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

    UserDefaultManager.setStringToUserDefaults(value:fcmToken!, key:UD_fcmToken)
  }
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    reveivedNotification(notification: userInfo as! [String : AnyObject])
    completionHandler()
  }
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("userInfo: \(userInfo.debugDescription)")
    reveivedNotification(notification: userInfo as! [String : AnyObject])
  }
  func reveivedNotification(notification: [String:AnyObject]) {
    print(notification)
  }
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("user clicked on the notification")
    let userInfo = notification.request.content.userInfo
    reveivedNotification(notification: userInfo as! [String : AnyObject])
    completionHandler([.banner,.badge,.sound])
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  @available(iOS 9, *)
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    if UserDefaults.standard.value(forKey: key_Type) as! String == key_google {
      return (GIDSignIn.sharedInstance.handle(url))
    }
    else {
      return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
  }

  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if UserDefaults.standard.value(forKey: key_Type) as! String == key_google {
      return (GIDSignIn.sharedInstance.handle(url))
    }
    else {
      return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
  }
}
