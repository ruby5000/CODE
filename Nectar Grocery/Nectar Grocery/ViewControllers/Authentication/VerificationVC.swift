import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase

class VerificationVC: UIViewController {

    @IBOutlet weak var txt_OTP: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnTap_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_next(_ sender: UIButton) {
        
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaultManager.getStringFromUserDefaults(key: "CODE"), verificationCode: self.txt_OTP.text!)
        Auth.auth().signIn(with: credentials) { (success, error) in
            if error == nil{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                showAlertMsg(Message: "Something went to wrong", AutoHide: true)
            }
        }
        
    }
}
