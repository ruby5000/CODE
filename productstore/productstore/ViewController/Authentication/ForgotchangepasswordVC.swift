import UIKit
import SwiftyJSON

class ForgotchangepasswordVC: UIViewController {
    
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var txt_confirmPassword: UITextField!
    @IBOutlet weak var txt_newPassword: UITextField!
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
//MARK: Button Action
extension ForgotchangepasswordVC
{
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btntap_submit(_ sender: Any) {
        
        if self.txt_confirmPassword.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: CONFIRMPASSWORD_MESSAGE)
        }
        else if self.txt_newPassword.text! == "" {
            showAlertMessage(titleStr: "", messageStr: PASSWORD_MESSAGE)
        }
        else if self.txt_newPassword.text! != self.txt_confirmPassword.text! {
            showAlertMessage(titleStr: "", messageStr: PASSWORD_CONFIRM_MESAAGE)
        }
        else
        {
            let urlString = API_URL + "fargot-password-save"
            let params: NSDictionary = ["email":self.email,"password":self.txt_newPassword.text!,"theme_id":APP_THEME]
            self.Webservice_Fargotpasswordsave(url: urlString, params: params)
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
extension ForgotchangepasswordVC
{
    func Webservice_Fargotpasswordsave(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                print(jsondata)
                let vc = MainstoryBoard.instantiateViewController(withIdentifier: "SucessChangepasswordVC") as! SucessChangepasswordVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
}
