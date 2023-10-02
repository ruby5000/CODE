
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }

    if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" {
      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      let objVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
      let nav : UINavigationController = UINavigationController(rootViewController: objVC)
      nav.navigationBar.isHidden = true
      self.window?.rootViewController = nav
      UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
    }
    else {
      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      let TabViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
      let appNavigation: UINavigationController = UINavigationController(rootViewController: TabViewController)
      appNavigation.setNavigationBarHidden(true, animated: true)
      self.window?.rootViewController = appNavigation
    }
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

}
