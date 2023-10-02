import UIKit
class loginVC: UIViewController {
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var lbl_accountNotFound: UILabel!
    @IBOutlet weak var btnTap_register: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnTap_register(_ sender: UIButton) {
        let registerVC = self.storyboard!.instantiateViewController(withIdentifier: "registerVC") as! registerVC
        navigationController?.pushViewController(registerVC, animated: true)
    }
    @IBAction func btnTap_login(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "USER_ARRAY") != nil {
            for i in UserDefaults.standard.object(forKey: "USER_ARRAY") as! [[String:String]] {
                if i["email"] == self.txt_email.text! && i["password"] == self.txt_password.text! {
                    let HomeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    navigationController?.pushViewController(HomeVC, animated: true)
                    UserDefaults.standard.set(i["fName"], forKey: "FIRST")
                } else {
                    self.btnTap_register.isHidden = false
                    self.lbl_accountNotFound.isHidden = false
                }
            }
        } else {
            self.btnTap_register.isHidden = false
            self.lbl_accountNotFound.isHidden = false
        }
    }
}
