import UIKit
import AMTabView
import NVActivityIndicatorView

class SettingVC: UIViewController, TabItem {

    @IBOutlet weak var view_visualBG: UIVisualEffectView!
    @IBOutlet weak var view_loader: NVActivityIndicatorView!
    
    var tabImage: UIImage? {
      return UIImage(named: "ic_Setting")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view_visualBG.isHidden = false
        DispatchQueue.main.async {
            self.setLoader()
        }
        if CONSTANT.GUEST_USER == true {
            
        }
        else {
            showAlert()
        }
        
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
    func showAlert() {
        
        let alrert  : UIAlertController = UIAlertController(title: "Log out", message: "Are you sure you want to log out", preferredStyle: .alert)
        let  rePlayButton  : UIAlertAction = UIAlertAction(title: "Yes", style: .default) {  (_) in
            UserDefaultManager.setStringToUserDefaults(value: "", key: CONSTANT.UD_UserName)
            CONSTANT.GUEST_USER = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let homeButton : UIAlertAction = UIAlertAction(title: "No", style: .destructive) { (_) in
            
        }
        alrert.addAction(rePlayButton)
        alrert.addAction(homeButton)
        present(alrert,animated: true,completion: nil)
    }
}
