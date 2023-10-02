import UIKit

class loginVC: UIViewController {
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var lbl_accountNotFound: UILabel!
    @IBOutlet weak var btnTap_register: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func alert_txt_validation(message:String) {
        let alert = UIAlertController(title: "Alert!!", message: message, preferredStyle: .alert)
        let btn_ok = UIAlertAction(title: "ok", style:UIAlertAction.Style.default) { UIAlertAction in }
        alert.addAction(btn_ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnTap_register(_ sender: UIButton) {
        let registerVC = self.storyboard!.instantiateViewController(withIdentifier: "registerVC") as! registerVC
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func btnTap_login(_ sender: UIButton) {
        if self.txt_email.text! == "" && self.txt_password.text! == "" {
            self.alert_txt_validation(message: "Please enter all details")
        }
        else if self.txt_email.text! == "" {
            self.alert_txt_validation(message: "Please enter email")
        }
        else if self.txt_password.text! == "" {
            self.alert_txt_validation(message: "Please enter password")
        }
        else {
            if UserDefaults.standard.object(forKey: "USER_ARRAY") != nil {
                for i in UserDefaults.standard.object(forKey: "USER_ARRAY") as! [[String:String]] {
                    if i["email"] == self.txt_email.text! && i["password"] == self.txt_password.text! {
                        
                        let HomeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        navigationController?.pushViewController(HomeVC, animated: true)
                        
                        UserDefaults.standard.set(i["dob"], forKey: "DOB")
                        UserDefaults.standard.set(i["fName"], forKey: "FIRST")
                        UserDefaults.standard.set(i["lName"], forKey: "LAST")
                        UserDefaults.standard.set(i["email"], forKey: "EMAIL")
                        UserDefaults.standard.set(i["password"], forKey: "PASS")
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
}
