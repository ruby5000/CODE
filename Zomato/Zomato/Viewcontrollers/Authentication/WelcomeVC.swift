import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import GoogleSignIn
import FBSDKCoreKit
import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import Firebase

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var txt_phoneNum: UITextField!
    @IBOutlet weak var btn_more: UIButton!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var btn_callingCode: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.googleLogin()
    }
    
    func googleLogin() {
        //        GIDSignIn.sharedInstance().presentingViewController = self
        //        GIDSignIn.sharedInstance().delegate = self
        //        print("\(String(describing: GIDSignIn.sharedInstance()?.currentUser))")
    }
    
        func appleSign() {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    
    @IBAction func btnTap_more(_ sender: UIButton) {
        self.showAlert()
    }
    
    
    @IBAction func btnTap_continue(_ sender: UIButton) {
        
        if self.txt_phoneNum.text! == "" {
            showAlertMsg(Message: "please enter mobile number", AutoHide: true)
        } else {
            let temp = (self.btn_callingCode.titleLabel?.text!)!
            let code = temp+self.txt_phoneNum.text!
            UserDefaultManager.setStringToUserDefaults(value: self.txt_phoneNum.text!, key: UD_phoneNumber)
            PhoneAuthProvider.provider().verifyPhoneNumber(code, uiDelegate: nil) { (verificationID, error) in
                if error == nil {
                    guard let veryfyID = verificationID else {return}
                    UserDefaultManager.setStringToUserDefaults(value: veryfyID, key: UD_VerificationID)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    showAlertMsg(Message: error!.localizedDescription, AutoHide: true)
                }
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController (title: Bundle.main.displayName!, message: "", preferredStyle: .actionSheet)
        let fbBtn = UIAlertAction(title: "Continue with Facebook", style: .default) { action in
            print("Facebook button tapped")
            //self.FacebookLogin()
        }
        let emailBtn  = UIAlertAction(title: "Continue with Email", style: .default) { action in
            print("email button tapped")
        }
        let appleBtn  = UIAlertAction(title: "Continue with Apple", style: .default) { action in
            print("apple button tapped")
            self.appleSign()
        }
        alert.addAction(fbBtn)
        alert.addAction(emailBtn)
        alert.addAction(appleBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnTap_laungage(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageMenuVC") as! LanguageMenuVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnTap_callingCode(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryCallingCodeVC") as! CountryCallingCodeVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTap_google(_ sender: UIButton) {
        //GIDSignIn.sharedInstance().signIn()
        
    }
}


// MARK: - Apple Login
extension WelcomeVC : ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Faild!!")

    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let firstName = credentials.fullName?.givenName
            let lastName = credentials.fullName?.familyName
            let email = credentials.email
            print("First Name = \(credentials.fullName?.givenName ?? "no first name")")
            print("Last Name = \(credentials.fullName?.familyName ?? "no last name")")
            print("Email = \(credentials.email ?? "no email")")
            break
        default:
            break
        }
    }
}
extension WelcomeVC : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
//
//
//extension WelcomeVC {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        print("Your email address = "+user.profile.email)
//        print("Full Name = "+user.profile.name)
//        print("Name = "+user.profile.familyName)
//
//    }
//}
