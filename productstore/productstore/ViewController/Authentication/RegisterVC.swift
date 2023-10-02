import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices
import SwiftyJSON

class RegisterVC: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  
}
//MARK: Button Actions
extension RegisterVC
{
    @IBAction func btnTap_Loginwithemail(_ sender: UIButton) {
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterWithEmailVC") as! RegisterWithEmailVC
      self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTap_Login(_ sender: UIButton) {
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
      self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTap_LoginwithFacebook(_ sender: UIButton) {
      self.FacebookLogin()
    }
    @IBAction func btnTap_LoginwithGoogle(_ sender: UIButton) {
      self.GoogleLogin()
    }
    @IBAction func btnTap_LoginwithApple(_ sender: UIButton) {
      self.AppleLogin()
    }
}
extension RegisterVC
{
  func FacebookLogin()
  {
    UserDefaults.standard.set(key_facebook, forKey: key_Type)
    let loginManager = LoginManager()
    loginManager.logIn(permissions: [.email], viewController: nil) { (loginResult) in
      switch loginResult {
        case .success( _, _, _):
          let dictParamaters = ["fields":"id, name, email"]
          let request: GraphRequest = GraphRequest.init(graphPath: "me", parameters: dictParamaters)
          request.start { (connection, result, error) in
            let responseData = result as! NSDictionary
            let facebookId = responseData["id"] as! String
            let name = responseData["name"] as! String
            var email = ""
            if responseData["email"] != nil {
              email = responseData["email"] as! String
            }
            loginManager.logOut()


            let urlString = API_URL + "register"
            let params: NSDictionary = ["first_name":name,
                                        "last_name":name,
                                        "email":email,
                                        "password":"",
                                        "mobile":"",
                                        "device_type":App_device_type,
                                        "register_type":"facebook",
                                        "google_id":"",
                                        "facebook_id":facebookId,
                                        "apple_id":"",
                                        "token":UserDefaultManager.getStringFromUserDefaults(key: UD_fcmToken),
                                        "theme_id":APP_THEME]
            self.Webservice_Register(url: urlString, params: params)

          }
          break
        case .cancelled:
          showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Something went wrong. Try again later")
          break
        case .failed( _):
          showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Something went wrong. Try again later")
          break
      }
    }
  }

  func GoogleLogin()
  {
    UserDefaults.standard.set(key_google, forKey: key_Type)
    let signInConfig = GIDConfiguration.init(clientID: GoogleClient_Id)
    GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in

      if error != nil {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Something went wrong. Try again later")
      }
      else {
        guard let user = user else { return }
        //   if let profiledata = user.profile {
        //  let userId : String = user.userID ?? ""
        let googleId = user.userID!
        //   let givenName : String = profiledata.givenName ?? ""
        // let familyName : String = profiledata.familyName ?? ""
        let name = user.profile?.name
        let email = user.profile?.email
        GIDSignIn.sharedInstance.disconnect()
        GIDSignIn.sharedInstance.signOut()

        let urlString = API_URL + "register"
        let params: NSDictionary = ["first_name":name!,
                                    "last_name":name!,
                                    "email":email!,
                                    "password":"",
                                    "mobile":"",
                                    "device_type":App_device_type,
                                    "register_type":"google",
                                    "google_id":googleId,
                                    "facebook_id":"",
                                    "apple_id":"",
                                    "token":UserDefaultManager.getStringFromUserDefaults(key: UD_fcmToken),
                                    "theme_id":APP_THEME]
        self.Webservice_Register(url: urlString, params: params)
      }
      guard error == nil else { return }
    }
  }

  func AppleLogin(){

    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }


}
extension RegisterVC: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
      case let appleIDCredential as ASAuthorizationAppleIDCredential:

        let userIdentifier = appleIDCredential.user
        var Email = String()
        var Fullname = String()
        if appleIDCredential.email != nil
        {
          Email = appleIDCredential.email!
          UserDefaultManager.setStringToUserDefaults(value: Email, key: UD_emailId)
        }
        else
        {
          Email = UserDefaultManager.getStringFromUserDefaults(key: UD_emailId)
        }
        //            print(appleIDCredential.fullName)
        if appleIDCredential.fullName?.givenName != nil
        {
          Fullname = (appleIDCredential.fullName?.givenName)! + (appleIDCredential.fullName?.familyName)!
          UserDefaultManager.setStringToUserDefaults(value: Fullname, key: UD_userFirstName)
        }
        else{
          Fullname = UserDefaultManager.getStringFromUserDefaults(key: UD_userFirstName)
        }

        let urlString = API_URL + "register"
        let params: NSDictionary = ["first_name":Fullname,
                                    "last_name":Fullname,
                                    "email":Email,
                                    "password":"",
                                    "mobile":"",
                                    "device_type":App_device_type,
                                    "register_type":"apple",
                                    "google_id":"",
                                    "facebook_id":"",
                                    "apple_id":userIdentifier,
                                    "token":UserDefaultManager.getStringFromUserDefaults(key: UD_fcmToken),
                                    "theme_id":APP_THEME]
        self.Webservice_Register(url: urlString, params: params)

        break
      default:
        break
    }
  }
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
//MARK: Api Calling Function
extension RegisterVC
{
  func Webservice_Register(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1"
      {
        let jsondata = jsonResponse!["data"].dictionaryValue
        print(jsondata)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["id"]!.stringValue, key: UD_userId)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["email"]!.stringValue, key: UD_emailId)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["first_name"]!.stringValue, key: UD_userFirstName)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["last_name"]!.stringValue, key: UD_userLastName)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["mobile"]!.stringValue, key: UD_userPhone)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["token"]!.stringValue, key: UD_BearerToken)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["token_type"]!.stringValue, key: UD_TokenType)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["image"]!.stringValue, key: UD_Userprofile)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["name"]!.stringValue, key: UD_userFullname)
        
        UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestObj)
        UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestProductArray)
        UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestTaxArray)

        UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_GuestTaxArray)
        UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_CouponObj)
        UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_BillingObj)

        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_PaymentType)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_PaymentDescription)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_Deliveryid)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_DeliveryDescription)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_CartCount)

        let objVC = MainstoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let TabViewController = MainstoryBoard.instantiateViewController(withIdentifier: "TababrVC") as! TababrVC
        let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
        appNavigation.setNavigationBarHidden(true, animated: true)
        keyWindow?.rootViewController = TabViewController
      }
      else
      {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}
