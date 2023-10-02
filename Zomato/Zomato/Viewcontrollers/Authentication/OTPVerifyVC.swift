import UIKit
import Alamofire
import SwiftyJSON
import FirebaseAuth
import FirebaseCore
import Firebase

class OTPVerifyVC: UIViewController {
    
    @IBOutlet weak var txt_otp: UITextField!
    @IBOutlet weak var lbl_phoneNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lbl_phoneNum.text! = UserDefaultManager.getStringFromUserDefaults(key: UD_phoneNumber)
    }
    
    @IBAction func btntap_back(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnTap_submit(_ sender: Any) {
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaultManager.getStringFromUserDefaults(key: UD_VerificationID), verificationCode: self.txt_otp.text!)
        Auth.auth().signIn(with: credentials) { (success, error) in
            if error == nil{
                print("Success")
            } else {
                showAlertMsg(Message: "Something went to wrong", AutoHide: true)
            }
        }
    }
}

