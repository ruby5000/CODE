import SwiftyJSON
import UIKit

class ForgotPasswordVC: UIViewController {

  @IBOutlet weak var texfiled_email: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func btnTap_login(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func btnTap_Submit(_ sender: UIButton) {
    if self.texfiled_email.text! == "" {
      showAlertMessage(titleStr: "", messageStr: EMAIL_MESSAGE)
    }
    else if isValidateEmail(email: self.texfiled_email.text!) == false{
      showAlertMessage(titleStr: "", messageStr: VALID_EMAIL_MESSAGE)
    }
    else {
      let urlString = "http://192.168.1.28/bookingdo/api/forgotpassword"
      let params: NSDictionary = ["email":self.texfiled_email.text!]
      self.Webservice_Fargotpasswordsendotp(url: urlString, params: params)
    }
  }

}


extension ForgotPasswordVC {

  // MARK: - Webservice_Fargotpasswordsendotp api calling
  func Webservice_Fargotpasswordsendotp(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      let status = jsonResponce!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponce!["data"].dictionaryValue
        print(jsondata)
        showAlertMsg(Message: jsonResponce!["message"].stringValue, AutoHide: true)
        self.navigationController?.popViewController(animated: true)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}
