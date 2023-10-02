import UIKit

class ChangePasswordVC: UIViewController {

  @IBOutlet weak var txt_OldPassword: UITextField!
  @IBOutlet weak var txt_NewPassword: UITextField!
  @IBOutlet weak var txt_ConfirmPassword: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
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
    else {
      let urlString = "https://store-mart.paponapps.co.in/api/changepassword"
      let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                  "old_password":self.txt_OldPassword.text!,
                                  "new_password":self.txt_NewPassword.text!
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
