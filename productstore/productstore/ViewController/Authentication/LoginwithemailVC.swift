import UIKit
import SwiftyJSON

class LoginwithemailVC: UIViewController {
    
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
//MARK: Button Actions
extension LoginwithemailVC
{
    @IBAction func btnTap_Signup(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTap_Login(_ sender: UIButton) {
        if self.txt_Email.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: EMAIL_MESSAGE)
        }
        else if self.txt_Password.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: PASSWORD_MESSAGE)
        }
        else if isValidateEmail(email: self.txt_Email.text!) == false
        {
            showAlertMessage(titleStr: "", messageStr: VALID_EMAIL_MESSAGE)
        }
        else{
            let urlString = API_URL + "login"
            let params: NSDictionary = ["email":self.txt_Email.text!,
                                        "password":self.txt_Password.text!,
                                        "device_type":App_device_type,
                                        "google_id":"",
                                        "facebook_id":"",
                                        "apple_id":"",
                                        "token":UserDefaultManager.getStringFromUserDefaults(key: UD_fcmToken),
                                        "theme_id":APP_THEME]
            self.Webservice_Login(url: urlString, params: params)
        }
    }
    
    @IBAction func btnTap_ForgotPassword(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotpasswordVC") as! ForgotpasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Api Calling Function
extension LoginwithemailVC
{
    func Webservice_Login(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                print(jsondata)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["id"]!.stringValue, key: UD_userId)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["email"]!.stringValue, key: UD_emailId)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["first_name"]!.stringValue, key: UD_userFirstName)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["last_name"]!.stringValue, key: UD_userLastName)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["mobile"]!.stringValue, key: UD_userPhone)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["token"]!.stringValue, key: UD_BearerToken)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["token_type"]!.stringValue, key: UD_TokenType)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["image"]!.stringValue, key: UD_Userprofile)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["name"]!.stringValue, key: UD_userFullname)
                
                UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestObj)
                UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestProductArray)
                UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestTaxArray)
                
                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_GuestTaxArray)
                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_CouponObj)
                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_BillingObj)
                
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_PaymentType)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_PaymentDescription)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_Deliveryid)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_DeliveryDescription)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_CartCount)
                
                let objVC = MainstoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                let TabViewController = MainstoryBoard.instantiateViewController(withIdentifier: "TababrVC") as! TababrVC
                let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
                appNavigation.setNavigationBarHidden(true, animated: true)
                keyWindow?.rootViewController = TabViewController
            }
            else
            {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
}
