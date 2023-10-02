import UIKit
import SwiftyJSON

class ForgotpasswordVC: UIViewController {
    @IBOutlet weak var txt_email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
//MARK: Button Actions
extension ForgotpasswordVC
{
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_SendCode(_ sender: UIButton) {
        if self.txt_email.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: EMAIL_MESSAGE)
        }
        else if isValidateEmail(email: self.txt_email.text!) == false{
            
            showAlertMessage(titleStr: "", messageStr: VALID_EMAIL_MESSAGE)
        }
        else{
            let urlString = API_URL + "fargot-password-send-otp"
            let params: NSDictionary = ["email":self.txt_email.text!,"theme_id":APP_THEME]
            self.Webservice_Fargotpasswordsendotp(url: urlString, params: params)
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
extension ForgotpasswordVC
{
    func Webservice_Fargotpasswordsendotp(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                print(jsondata)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                vc.email = self.txt_email.text!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
}
