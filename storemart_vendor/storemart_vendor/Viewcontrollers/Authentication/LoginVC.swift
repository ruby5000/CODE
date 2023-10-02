import UIKit
import SwiftyJSON
import Alamofire

class LoginVC: UIViewController {

  @IBOutlet weak var texFiled_Email: UITextField!
  @IBOutlet weak var textFiled_Password: UITextField!
  @IBOutlet weak var eyeBtn: UIButton!

  var iconClick = false
  var arrJson : ()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func btnTap_signUp(_ sender: UIButton) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
    self.navigationController?.pushViewController(objVC, animated: true)
  }

  @IBAction func eyeBtn(_ sender: UIButton) {
    if(iconClick == true) {
      textFiled_Password.isSecureTextEntry = false
      eyeBtn.setImage(UIImage(systemName: "eye"), for: .normal)
    } else {
      textFiled_Password.isSecureTextEntry = true
      eyeBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    iconClick = !iconClick
  }

  @IBAction func forgotPasswordBtn(_ sender: UIButton) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
    self.navigationController?.pushViewController(objVC, animated: true)
  }

  @IBAction func loginBtn(_ sender: UIButton) {
    if self.texFiled_Email.text! == "" {
      showAlertMessage(titleStr: "", messageStr: EMAIL_MESSAGE)
    }
    else if self.textFiled_Password.text! == ""  {
      showAlertMessage(titleStr: "", messageStr: PASSWORD_MESSAGE)
    }
    else if isValidateEmail(email: self.texFiled_Email.text!) == false  {
      showAlertMessage(titleStr: "", messageStr: VALID_EMAIL_MESSAGE)
    }
    else{
      let urlString = "https://store-mart.paponapps.co.in/api/login"
      let params: NSDictionary = ["email":self.texFiled_Email.text!,
                                  "password":self.textFiled_Password.text!]
      self.Webservice_login(url: urlString, params: params)
    }
  }
}

extension LoginVC {

  // MARK: - login api calling
  func Webservice_login(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters: params, httpMethod: "POST", progressView: true, uiView: self.view, networkAlert: true)
    {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponse!["data"].dictionaryValue
        print(jsondata["email"]!.stringValue)

        UserDefaultManager.setStringToUserDefaults(value: jsondata["id"]!.stringValue, key: UD_userId)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["email"]!.stringValue, key: UD_emailId)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["name"]!.stringValue, key: UD_userFullname)
        UserDefaultManager.setStringToUserDefaults(value: jsondata["mobile"]!.stringValue, key: UD_userPhone)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let TabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        self.navigationController?.pushViewController(TabbarVC, animated: true)
      }
      else if status == "2" {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
        vc.email = jsonResponse!["email"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue)
      }
    }
  }
}
