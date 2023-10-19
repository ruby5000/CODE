import UIKit
import Firebase
import FirebaseDatabase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var btn_eye: UIButton!
    
    var iconClick = false
    var dataStorege: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataStorege = Database.database().reference().child("UserData")
    }
    
    
    @IBAction func btnTap_eye(_ sender: UIButton) {
        if(iconClick == true) {
            txt_password.isSecureTextEntry = false
            btn_eye.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        else {
            txt_password.isSecureTextEntry = true
            btn_eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        iconClick = !iconClick
    }
    
    @IBAction func btnTap_Signup(_ sender: UIButton) {
        if self.txt_username.text! == "" && self.txt_email.text! == "" && self.txt_password.text! == "" {
            showAlertMsg(Message: "Please enter all details", AutoHide: true)
        }
        else if self.txt_username.text! == "" {
            showAlertMsg(Message: "Please enter username", AutoHide: true)
        }
        else if self.txt_email.text! == "" {
            showAlertMsg(Message: "Please enter email", AutoHide: true)
        }
        else if self.txt_password.text! == "" {
            showAlertMsg(Message: "Please enter paswword", AutoHide: true)
        }
        else {
            insertUserData()
        }
    }
    
    @IBAction func btnTap_login(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SignUpVC {
    func insertUserData() {
        let key = dataStorege.childByAutoId().key
        let userData = ["id":key,
                      "name": txt_username.text! as String,
                      "email": txt_email.text! as String,
                      "password": txt_password.text! as String
        ]
        dataStorege.child(key!).setValue(userData)
        print(userData)
        showAlertMsg(Message: "Congratulations, your account has been successfully created.", AutoHide: true)
        txt_username.text = ""
        txt_email.text = ""
        txt_password.text = ""
    }
}
