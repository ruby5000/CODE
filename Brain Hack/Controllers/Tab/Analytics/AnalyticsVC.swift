import UIKit
import AMTabView
import NVActivityIndicatorView

class AnalyticsVC: UIViewController, TabItem {

    @IBOutlet weak var view_visualBG: UIVisualEffectView!
    @IBOutlet weak var view_loader: NVActivityIndicatorView!
    @IBOutlet weak var lbl_timer: UILabel!
    @IBOutlet weak var lbl_Total_timer: UILabel! 
    
    var tabImage: UIImage? {
      return UIImage(named: "ic_analytics")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_Total_timer.text! = UserDefaultManager.getStringFromUserDefaults(key: "TOTAL_TIME")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view_visualBG.isHidden = false
        DispatchQueue.main.async {
            self.setLoader()
        }
        self.lbl_timer.text! = "\(UserDefaultManager.getFloatFromUserDefaults(key: "TIMER"))"
        UserDefaultManager.setStringToUserDefaults(value: self.lbl_timer.text!, key: "TOTAL_TIME")
        
    }
    
    func setLoader() {
        self.view_loader.type = .ballSpinFadeLoader
        self.view_loader.color = UIColor(named: "Primary_color_2")!
        self.view_loader.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view_visualBG.isHidden = true
            self.view_loader.stopAnimating()
        }
    }
}
