import UIKit
import SwiftyJSON

class RegisterVC: UIViewController {

  @IBOutlet weak var texfiled_fullname: UITextField!
  @IBOutlet weak var texfiled_email: UITextField!
  @IBOutlet weak var texfiled_mobile: UITextField!
  @IBOutlet weak var texfiled_password: UITextField!
  @IBOutlet weak var eyeBtn: UIButton!

  var iconClick = false

  override func viewDidLoad() {
    super.viewDidLoad()
    self.texfiled_fullname.placeHolderColor = .lightGray
    self.texfiled_email.placeHolderColor = .lightGray
    self.texfiled_mobile.placeHolderColor = .lightGray
    self.texfiled_password.placeHolderColor = .lightGray
  }

  @IBAction func btnTap_login(_ sender: Any) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func eyeBtn(_ sender: UIButton) {
    if(iconClick == true) {
      texfiled_password.isSecureTextEntry = false
      eyeBtn.setImage(UIImage(systemName: "eye"), for: .normal)
    } else {
      texfiled_password.isSecureTextEntry = true
      eyeBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    iconClick = !iconClick
  }

  @IBAction func btnTap_Signup(_ sender: UIButton) {
    if texfiled_email.text == "" && texfiled_password.text == "" && texfiled_fullname.text == "" &&
        texfiled_mobile.text == "" {
      showAlertMessage(titleStr: "", messageStr: "Please enter all details.")
    }
    else if texfiled_email.text == "" {
      showAlertMessage(titleStr: "", messageStr: "Please enter email.")
    } else if isValidateEmail(email: self.texfiled_email.text!) == false {
      showAlertMessage(titleStr: "", messageStr: "Please enter valid email address.")
    } else if texfiled_fullname.text == "" {
      showAlertMessage(titleStr: "", messageStr: "Please enter name.")
    } else if texfiled_mobile.text == "" {
      showAlertMessage(titleStr: "", messageStr: "Please enter mobile number.")
    } else if texfiled_password.text == "" {
      showAlertMessage(titleStr: "", messageStr: "Please enter password.")
    }
    else {
      let parameters =
      [
        "name":self.texfiled_fullname.text!,
        "mobile":self.texfiled_mobile.text!,
        "password":self.texfiled_password.text!,
        "email":self.texfiled_email.text!
      ] as NSDictionary
      Webservice_Signup(url: "http://192.168.1.28/ecom-saas/api/register", params:parameters)
    }
  }
}


extension RegisterVC {
  // MARK: - Signup page api
  func Webservice_Signup(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
      if strErrorMessage.count != 0 {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
      }
      else {
        let responseCode = jsonResponse!["status"].stringValue
        if responseCode == "1" {
          let jsondata = jsonResponse!["data"].dictionaryValue
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
          UserDefaultManager.setStringToUserDefaults(value: jsondata["id"]!.stringValue, key: UD_userId)
          UserDefaultManager.setStringToUserDefaults(value: jsondata["email"]!.stringValue, key: UD_emailId)
          UserDefaultManager.setStringToUserDefaults(value: jsondata["name"]!.stringValue, key: UD_userFullname)
          UserDefaultManager.setStringToUserDefaults(value: jsondata["mobile"]!.stringValue, key: UD_userPhone)
          UserDefaultManager.setStringToUserDefaults(value: jsondata["image"]!.stringValue, key: UD_Userprofile)
          self.navigationController?.pushViewController(vc, animated: true)
          print(jsondata)
        }
        else if responseCode == "2" {
          let jsondata = jsonResponse!["data"].dictionaryValue
          print(jsondata)
        }
        else {
          showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
        }
      }
    }
  }
}
