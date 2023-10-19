import UIKit
import Firebase
import FirebaseDatabase

class LoginVC: UIViewController {
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var btn_eye: UIButton!
    @IBOutlet weak var txt_password: UITextField!
    
    var dataStorege: DatabaseReference!
    var arrUserData = [UserDataModel]()
    var iconClick = false
    
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
    
    @IBAction func btnTap_Login(_ sender: UIButton) {
        if self.txt_email.text! == "" && self.txt_password.text! == "" {
            showAlertMsg(Message: "Please enter all details", AutoHide: true)
        }
        else if self.txt_email.text! == "" {
            showAlertMsg(Message: "Please enter email ID", AutoHide: true)
        }
        else if self.txt_password.text! == "" {
            showAlertMsg(Message: "Please enter password", AutoHide: true)
        }
        else {
            dataStorege.observe(DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    for i in snapshot.children.allObjects as! [DataSnapshot] {
                        let data = i.value as? [String: AnyObject]
                        if self.txt_email.text! == data?["name"] as! String && self.txt_password.text! == data?["password"] as! String {
                           showAlertMsg(Message: "Success", AutoHide: true)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                let vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func btnTap_signUp(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
