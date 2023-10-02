import UIKit
import SwiftyJSON

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
//MARK: Button Actions
extension ChangePasswordVC
{
    
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_Save(_ sender: UIButton) {
        if self.txt_password.text == "" {
            showAlertMessage(titleStr: "", messageStr: PASSWORD_MESSAGE)
        } else if self.txt_confirmPassword.text == "" {
            showAlertMessage(titleStr: "", messageStr: CONFIRMPASSWORD_MESSAGE)
        } else if self.txt_password.text != self.txt_confirmPassword.text {
            showAlertMessage(titleStr: "", messageStr: PASSWORD_CONFIRM_MESAAGE)
        }
        else {
            let urlString = API_URL + "change-password"
            let headers:NSDictionary = ["Content-type":"application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params:NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                       "password":self.txt_password.text!,"theme_id":APP_THEME]
            self.Webservice_ChangePassword(url: urlString, params: params, header: headers)
        }
    }
    
}
extension ChangePasswordVC {
    func Webservice_ChangePassword(url:String, params:NSDictionary, header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters: params, httpMethod: "POST", progressView: true, uiView: self.view, networkAlert: true)
        {(_ jsonResponse:JSON? , _ statusCode:String) in
            
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                self.navigationController?.popViewController(animated: true)
            }
            else if status == "9"
            {
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_TokenType)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else
            {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
}
