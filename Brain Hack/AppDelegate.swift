import UIKit
import FirebaseCore
import FirebaseMessaging
import Firebase
import FirebaseAuth
import UserNotifications
import AMTabView
import GoogleMobileAds
import IQKeyboardManagerSwift
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var counter = 0
    var timer = Timer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        AMTabView.settings.ballColor = UIColor.init(named: "Primary_color_2")!
        AMTabView.settings.tabColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        AMTabView.settings.selectedTabTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        AMTabView.settings.unSelectedTabTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        AMTabView.settings.animationDuration = 1
        IQKeyboardManager.shared.enable = true
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("User gave permissions for local notifications")
            }
        }
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = TabVC()
            self.window = window
            window.makeKeyAndVisible()
        }
        
        window?.rootViewController = UINavigationController(rootViewController: TabVC())
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.debugDescription()
        Messaging.messaging().delegate = self
        ADsManager.shared.InterstitialADs()
        ADsManager.shared.loadRewardedAd()
        self.saveContext()
        
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
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        return true
    }
    
    @objc func timerAction() {
        counter += 1
        print(counter)
        UserDefaultManager.setFloatToUserDefaults(value: Float(counter), key: "TIMER")
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
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        UserDefaultManager.setStringToUserDefaults(value:fcmToken!, key: CONSTANT.UD_fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        reveivedNotification(notification: userInfo as! [String : AnyObject])
        completionHandler()
    }
    
    func reveivedNotification(notification: [String:AnyObject]) {
        print(notification)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("user clicked on the notification")
        let userInfo = notification.request.content.userInfo
        reveivedNotification(notification: userInfo as! [String : AnyObject])
        if #available(iOS 14.0, *) {
            completionHandler([.banner,.badge,.sound])
        } else {
            // Fallback on earlier versions
            
        }
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        timer.invalidate()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "USER_DATA")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
