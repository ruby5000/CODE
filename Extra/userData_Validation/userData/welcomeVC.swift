import UIKit

class welcomeVC: UIViewController {
    
    @IBOutlet weak var btn_viewData: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "USER_ARRAY") == nil {
            self.btn_viewData.isHidden = true
        } else {
            self.btn_viewData.isHidden = false
        }
    }
    
    @IBAction func btnTap_Login(_ sender: UIButton) {
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "loginVC") as! loginVC
        navigationController?.pushViewController(loginVC, animated: true)
    }
    @IBAction func btnTap_register(_ sender: UIButton) {
        let registerVC = self.storyboard!.instantiateViewController(withIdentifier: "registerVC") as! registerVC
        navigationController?.pushViewController(registerVC, animated: true)
    }
    @IBAction func btnTapViewList(_ sender: UIButton) {
        let userListVC = self.storyboard!.instantiateViewController(withIdentifier: "userListVC") as! userListVC
        navigationController?.pushViewController(userListVC, animated: true)
    }
}
