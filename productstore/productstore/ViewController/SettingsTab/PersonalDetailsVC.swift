import UIKit
import SwiftyJSON

class PersonalDetailsVC: UIViewController {
    
    @IBOutlet weak var txt_phone: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_FirstName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_email.text = UserDefaultManager.getStringFromUserDefaults(key: UD_emailId)
        self.txt_phone.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userPhone)
        self.txt_FirstName.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userFirstName)
        self.txt_LastName.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userLastName)
    }
    
}
//MARK: Button Actions
extension PersonalDetailsVC
{
    @IBAction func btnTap_Back(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTap_Save(_ sender: UIButton) {
        if self.txt_email.text == ""
        {
            showAlertMessage(titleStr: "", messageStr: EMAIL_MESSAGE)
        }
        else if self.txt_phone.text == ""
        {
            showAlertMessage(titleStr: "", messageStr: PHONE_MESSAGE)
        }
        else if self.txt_FirstName.text == ""
        {
            showAlertMessage(titleStr: "", messageStr: FIRST_MESSAGE)
        }
        else if self.txt_LastName.text == ""
        {
            showAlertMessage(titleStr: "", messageStr: LASTNAME_MESSAGE)
        }
        else
        {
            UserDefaultManager.setStringToUserDefaults(value: self.txt_email.text!, key: UD_emailId)
            UserDefaultManager.setStringToUserDefaults(value: self.txt_phone.text!, key: UD_userPhone)
            UserDefaultManager.setStringToUserDefaults(value: self.txt_FirstName.text!, key: UD_userFirstName)
            UserDefaultManager.setStringToUserDefaults(value: self.txt_LastName.text!, key: UD_userLastName)
            
            let urlString = API_URL + "profile-update"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"first_name":UserDefaultManager.getStringFromUserDefaults(key: UD_userFirstName),"last_name":UserDefaultManager.getStringFromUserDefaults(key: UD_userLastName),"email":UserDefaultManager.getStringFromUserDefaults(key: UD_emailId),"telephone":UserDefaultManager.getStringFromUserDefaults(key: UD_userPhone),"theme_id":APP_THEME]
            self.Webservice_ProfileUpdate(url: urlString, params: params, header: headers)
            
        }
    }
}
extension PersonalDetailsVC
{
    func Webservice_ProfileUpdate(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"]["data"].dictionaryValue
                UserDefaultManager.setStringToUserDefaults(value: jsondata["email"]!.stringValue, key: UD_emailId)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["first_name"]!.stringValue, key: UD_userFirstName)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["last_name"]!.stringValue, key: UD_userLastName)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["mobile"]!.stringValue, key: UD_userPhone)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["image"]!.stringValue, key: UD_Userprofile)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["name"]!.stringValue, key: UD_userFullname)
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
