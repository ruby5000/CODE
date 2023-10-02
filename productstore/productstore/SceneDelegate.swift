
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
      
      if UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken) == "N/A" {
          
          UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
          UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
          UserDefaultManager.setStringToUserDefaults(value: "", key: UD_TokenType)
          UserDefaultManager.setStringToUserDefaults(value: "", key: UD_CartCount)
          let storyBoard = UIStoryboard(name: "Main", bundle: nil)
          let TabViewController = storyBoard.instantiateViewController(withIdentifier: "TababrVC") as! TababrVC
          let appNavigation: UINavigationController = UINavigationController(rootViewController: TabViewController)
          appNavigation.setNavigationBarHidden(true, animated: true)
          self.window?.rootViewController = appNavigation
      }
      else
      {
          let storyBoard = UIStoryboard(name: "Main", bundle: nil)
          let TabViewController = storyBoard.instantiateViewController(withIdentifier: "TababrVC") as! TababrVC
          let appNavigation: UINavigationController = UINavigationController(rootViewController: TabViewController)
          appNavigation.setNavigationBarHidden(true, animated: true)
          self.window?.rootViewController = appNavigation
      }
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let TabViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
//        let appNavigation: UINavigationController = UINavigationController(rootViewController: TabViewController)
//        appNavigation.setNavigationBarHidden(true, animated: true)
//        self.window?.rootViewController = appNavigation
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

