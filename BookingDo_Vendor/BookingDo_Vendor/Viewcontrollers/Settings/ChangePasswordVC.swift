import UIKit

class ChangePasswordVC: UIViewController {

  @IBOutlet weak var txt_OldPassword: UITextField!
  @IBOutlet weak var txt_NewPassword: UITextField!
  @IBOutlet weak var txt_ConfirmPassword: UITextField!
  @IBOutlet weak var eyeBtn_oldPasswrd: UIButton!
  @IBOutlet weak var eyeBtn_NewPassword: UIButton!
  @IBOutlet weak var eyeBtn_ConfirmPassword: UIButton!

  var iconClick = false

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func eyeBtn_Oldpassword(_ sender: UIButton) {
    if(iconClick == true) {
      txt_OldPassword.isSecureTextEntry = false
      eyeBtn_oldPasswrd.setImage(UIImage(systemName: "eye"), for: .normal)
    } else {
      txt_OldPassword.isSecureTextEntry = true
      eyeBtn_oldPasswrd.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    iconClick = !iconClick
  }

  @IBAction func eyeBtn_NewPassword(_ sender: UIButton) {
    if(iconClick == true) {
      txt_NewPassword.isSecureTextEntry = false
      eyeBtn_NewPassword.setImage(UIImage(systemName: "eye"), for: .normal)
    } else {
      txt_NewPassword.isSecureTextEntry = true
      eyeBtn_NewPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    iconClick = !iconClick
  }

  @IBAction func eyeBtn_ConfirmPassword(_ sender: UIButton) {
    if(iconClick == true) {
      txt_ConfirmPassword.isSecureTextEntry = false
      eyeBtn_ConfirmPassword.setImage(UIImage(systemName: "eye"), for: .normal)
    } else {
      txt_ConfirmPassword.isSecureTextEntry = true
      eyeBtn_ConfirmPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    iconClick = !iconClick
  }

  @IBAction func btnTap_Reset(_ sender: UIButton) {
    if self.txt_OldPassword.text == "" {
      showAlertMessage(titleStr: "", messageStr: "enter old password")
    }
    if self.txt_NewPassword.text! == "" {
      showAlertMessage(titleStr: "", messageStr: "enter new password")
    }
    if self.txt_ConfirmPassword.text! == "" {
      showAlertMessage(titleStr: "", messageStr: "enter confirm password")
    }
    if self.txt_NewPassword.text! != self.txt_ConfirmPassword.text! {
      showAlertMessage(titleStr: "", messageStr: "new passsword and confirm password is not match")
    }
    else {
      let urlString = "http://192.168.1.28/bookingdo/api/changepassword"
      let params: NSDictionary = ["vendor_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                  "current_password":self.txt_OldPassword.text!,
                                  "new_password":self.txt_NewPassword.text!,
                                  "confirm_password":self.txt_ConfirmPassword.text!
      ]
      self.Webservice_changePassword(url: urlString, params: params)
    }
  }
}



extension ChangePasswordVC {
  func Webservice_changePassword(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters: params, httpMethod: "POST", progressView: true, uiView: self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      if strErrorMessage.count != 0 {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
      }
      else {
        let responseCode = jsonResponce!["status"].stringValue
        if responseCode == "1" {
          self.navigationController?.popViewController(animated: true)
        }
        else {
          showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
}
