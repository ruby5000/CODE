import UIKit

class registerVC: UIViewController {
    
    @IBOutlet weak var txt_dob: UITextField!
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    
    var arrUser = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnTap_signup(_ sender: UIButton) {
        
        let userDict = ["dob":self.txt_dob.text!,
                        "fName":self.txt_firstName.text!,
                        "lName":self.txt_lastName.text!,
                        "email":self.txt_email.text!,
                        "password":self.txt_password.text!]
        
        if UserDefaults.standard.object(forKey: "USER_ARRAY") as? [[String : String]] == nil {
            self.arrUser.append(userDict)
            UserDefaults.standard.set(self.arrUser, forKey: "USER_ARRAY")
        } else {
            self.arrUser = UserDefaults.standard.object(forKey: "USER_ARRAY") as! [[String : String]]
            self.arrUser.append(userDict)
            UserDefaults.standard.set(self.arrUser, forKey: "USER_ARRAY")
        }
        
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "welcomeVC") as! welcomeVC
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
