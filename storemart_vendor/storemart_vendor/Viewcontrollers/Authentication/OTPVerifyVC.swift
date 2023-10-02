import UIKit
import SwiftyJSON
import Alamofire

class OTPVerifyVC: UIViewController {

  @IBOutlet weak var textfiled_OTP: UITextField!
  
  var email = String()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func btnTapBack(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func submitBtn(_ sender: UIButton) {
//    if self.textfiled_OTP.text! == "" {
//      showAlertMessage(titleStr: "", messageStr: OTP_MESSAGE)
//    }
//    else {
//      let urlString = "https://store-mart.paponapps.co.in/api/login"
//      let params: NSDictionary = ["email":self.email,"otp":self.textfiled_OTP.text!]
//      self.Webservice_Fargotpasswordverifyotp(url: urlString, params: params)
//    }
  }
}


extension OTPVerifyVC {
  func Webservice_Fargotpasswordverifyotp(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponse!["data"].dictionaryValue
        print(jsondata)
        let vc = MainstoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue)
      }
    }
  }
}
