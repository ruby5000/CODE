import UIKit

class registerVC: UIViewController {
    
    @IBOutlet weak var txt_dob: UITextField!
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    
    var arrUserData = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func alert_txt_validation(message:String) {
        let alert = UIAlertController(title: "ALERT!", message: message, preferredStyle: .alert)
        let btn_ok = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { UIAlertAction in }
        alert.addAction(btn_ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnTap_signup(_ sender: UIButton) {
        
        let userDict = ["dob":self.txt_dob.text!,
                        "fName":self.txt_firstName.text!,
                        "lName":self.txt_lastName.text!,
                        "email":self.txt_email.text!,
                        "password":self.txt_password.text!,
                        "img":""] as [String : Any]
        
        if self.txt_dob.text! == "" && self.txt_firstName.text! == "" && self.txt_lastName.text! == "" && self.txt_email.text! == "" && self.txt_password.text! == "" {
            self.alert_txt_validation(message: "Please enter all details")
        }
        else if self.txt_dob.text! == "" {
            self.alert_txt_validation(message: "Please enter D.O.B")
        }
        else if self.txt_firstName.text! == "" {
            self.alert_txt_validation(message: "Please enter first name")
        }
        else if self.txt_lastName.text! == "" {
            self.alert_txt_validation(message: "Please enter last name")
        }
        else if self.txt_email.text! == "" {
            self.alert_txt_validation(message: "Please enter email")
        }
        else if self.txt_password.text! == "" {
            self.alert_txt_validation(message: "Please enter password")
        }
        else {
            if UserDefaults.standard.object(forKey: "USER_ARRAY") as? [[String : Any]] == nil {
                self.arrUserData.append(userDict)
                UserDefaults.standard.set(self.arrUserData, forKey: "USER_ARRAY")
            } else {
                for i in UserDefaults.standard.object(forKey: "USER_ARRAY") as! [[String:Any]] {
                    if i["email"]! as! String == self.txt_email.text! {
                        self.alert_txt_validation(message: "This email has already exist!")
                    } 
                }
                self.arrUserData = UserDefaults.standard.object(forKey: "USER_ARRAY") as! [[String : Any]]
                self.arrUserData.append(userDict)
                UserDefaults.standard.set(self.arrUserData, forKey: "USER_ARRAY")
            }
            let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "welcomeVC") as! welcomeVC
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
