

import UIKit

class TababrVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (self.tabBar.items!)[2]{
            NotificationCenter.default.post(name: Notification.Name("NOTIFICATION_CENTER_TAB"), object: nil)
        }
    }

}
