import UIKit
import SwiftyJSON

class OTPVC: UIViewController {
    @IBOutlet weak var txt_OTP: UITextField!
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
//MARK: Button Action
extension OTPVC
{
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_SendCode(_ sender: UIButton) {
        if self.txt_OTP.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: OTP_MESSAGE)
        }
        else{
            let urlString = API_URL + "fargot-password-verify-otp"
            let params: NSDictionary = ["email":self.email,"otp":self.txt_OTP.text!,"theme_id":APP_THEME]
            self.Webservice_Fargotpasswordverifyotp(url: urlString, params: params)
        }
    }
    
    @IBAction func btnTap_ContactUs(_ sender: UIButton) {
        guard let url = URL(string: UserDefaultManager.getStringFromUserDefaults(key: UD_ContactusURL)) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
//MARK: Api Calling Function
extension OTPVC
{
    func Webservice_Fargotpasswordverifyotp(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                print(jsondata)
                let vc = MainstoryBoard.instantiateViewController(withIdentifier: "ForgotchangepasswordVC") as! ForgotchangepasswordVC
                vc.email = self.email
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
}
