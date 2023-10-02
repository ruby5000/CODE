import UIKit

class WelcomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
//MARK: Button Actions
extension WelcomeVC
{
    
    @IBAction func btnTap_Login(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTap_Signup(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTap_Guest(_ sender: UIButton) {
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_TokenType)
        
        let count = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
        if count == "" || count == "N/A"
        {
            UserDefaultManager.setStringToUserDefaults(value: "", key: UD_CartCount)
        }
        
        let objVC = MainstoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let TabViewController = MainstoryBoard.instantiateViewController(withIdentifier: "TababrVC") as! TababrVC
        let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
        appNavigation.setNavigationBarHidden(true, animated: true)
        keyWindow?.rootViewController = TabViewController
    }
}

