import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase


class NumberVC: UIViewController {

    @IBOutlet weak var txt_number: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnTap_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_next(_ sender: UIButton) {
        
        if self.txt_number.text! == "" {
            showAlertMsg(Message: "please enter mobile number", AutoHide: true)
        }
        else {
            PhoneAuthProvider.provider().verifyPhoneNumber(self.txt_number.text!, uiDelegate: nil) { (verificationID, error) in
                if error == nil {
                    guard let veryfyID = verificationID else {return}
                    UserDefaultManager.setStringToUserDefaults(value: veryfyID, key: "CODE")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    showAlertMsg(Message: error!.localizedDescription, AutoHide: true)
                }
            }
        }
    }
}
