 import UIKit

class EditProfileVC: UIViewController {

  @IBOutlet weak var txt_name: UITextField!
  @IBOutlet weak var txt_email: UITextField!
  @IBOutlet weak var txt_mobileNumber: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.txt_name.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userFullname)
    self.txt_email.text = UserDefaultManager.getStringFromUserDefaults(key: UD_emailId)
    self.txt_mobileNumber.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userPhone)
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func btnTap_save(_ sender: UIButton) {
    if self.txt_name.text == "" {
      showAlertMessage(titleStr: "", messageStr: "enter full name")
    }
    if self.txt_email.text! == "" {
      showAlertMessage(titleStr: "", messageStr: "enter email")
    }
    if self.txt_mobileNumber.text! == "" {
      showAlertMessage(titleStr: "", messageStr: "enter mobile number")
    }
    else {
      let urlString = "https://store-mart.paponapps.co.in/api/editprofile"
      let params: NSDictionary = ["name":self.txt_name.text!,
                                  "user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
      self.Webservice_editprofile(url: urlString, params: params)
    }
  }
}


extension EditProfileVC {
  func Webservice_editprofile(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters: params, httpMethod: "POST", progressView: true, uiView: self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      if strErrorMessage.count != 0 {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
      }
      else {
        let responseCode = jsonResponce!["status"].stringValue
        if responseCode == "1" {
          UserDefaultManager.setStringToUserDefaults(value: self.txt_name.text!, key: UD_userFullname)
          self.navigationController?.popViewController(animated: true)
        }
        else {
          showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
}
