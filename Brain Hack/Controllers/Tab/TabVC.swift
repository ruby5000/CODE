import UIKit
import AMTabView

class TabVC: AMTabsViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTabsControllers()
    selectedTabIndex = 0
  }

  public func setTabsControllers() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC")
    let AnalyticsVC = storyboard.instantiateViewController(withIdentifier: "AnalyticsVC")
    let SettingVC = storyboard.instantiateViewController(withIdentifier: "SettingVC")

    viewControllers = [
        HomeVC,
        AnalyticsVC,
        SettingVC
    ]
  }

  override func tabDidSelectAt(index: Int) {
    super.tabDidSelectAt(index: index)
  }
}
