

import UIKit
import SwiftyJSON
import iOSDropDown

class Guest_BillingDetailsVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Telephone: UITextField!
    
    //@IBOutlet weak var txt_saveAddress: UITextField!
    @IBOutlet weak var txt_Address1: UITextField!
    @IBOutlet weak var txt_Postcode: UITextField!
    
    @IBOutlet weak var txt_country: DropDown!
    @IBOutlet weak var txt_State: DropDown!
    @IBOutlet weak var txt_City: DropDown!
    
    @IBOutlet weak var txt_delivery_country: DropDown!
    @IBOutlet weak var txt_delivery_State: DropDown!
    @IBOutlet weak var txt_delivery_City: DropDown!
    
    @IBOutlet weak var Height_DeliveryView: NSLayoutConstraint!
    @IBOutlet weak var View_Delivery: UIView!
    
    @IBOutlet weak var txt_Delivery_Address1: UITextField!
    @IBOutlet weak var txt_Delivery_Postcode: UITextField!
    
    var Country_Array = [JSON]()
    var State_Array = [JSON]()
    var City_Array = [JSON]()
    
    var Country_Delivery_Array = [JSON]()
    var State_Delivery_Array = [JSON]()
    var City_Delivery_Array = [JSON]()
    var isdefault_address = String()
    
    var selectedCounty_id = String()
    var selectedState_id = String()
    var selectedCity_id = String()
    
    var selectedCounty_Delivery_id = String()
    var selectedState_Delivery_id = String()
    var selectedCity_Delivery_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_Postcode.delegate = self
        self.txt_Delivery_Postcode.delegate = self
        self.View_Delivery.isHidden = true
        self.Height_DeliveryView.constant = 0.0
        self.btn_check.setImage(UIImage.init(systemName: "checkmark.square.fill"), for: .normal)
        let urlString = API_URL + "country-list"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["theme_id":APP_THEME]
        self.Webservice_Countrylist(url: urlString, params: params, header: headers)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txt_Postcode
        {
            return range.location < 6 //Here 6 is your character limit
        }
        else
        {
            return range.location < 6 //Here 6 is your character limit
        }
        
    }
}
//MARK: Button Action
extension Guest_BillingDetailsVC
{
    @IBAction func btnTap_checkmark(_ sender: UIButton) {
        if self.btn_check.imageView?.image == UIImage.init(systemName: "square")
        {
            self.btn_check.setImage(UIImage.init(systemName: "checkmark.square.fill"), for: .normal)
            self.View_Delivery.isHidden = true
            self.Height_DeliveryView.constant = 0.0
        }
        else{
            self.btn_check.setImage(UIImage.init(systemName: "square"), for: .normal)
            self.View_Delivery.isHidden = false
            self.Height_DeliveryView.constant = 450.0
        }
    }
    
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func txtTap_Country(_ sender: DropDown) {
        var country_Name = [String]()
        for data in Country_Array
        {
            country_Name.append(data["name"].stringValue)
        }
        self.txt_country.textColor = .white
        self.txt_country.checkMarkEnabled = false
        self.txt_country.optionArray = country_Name
        self.txt_country.selectedRowColor = UIColor.init(named: "White_light")!
        self.txt_country.rowBackgroundColor  = UIColor.init(named: "White_light")!
        self.txt_country.itemsColor = UIColor(named: "Primary_Color")!
        self.txt_State.text = ""
        self.txt_City.text = ""
        self.selectedCity_id = ""
        self.selectedState_id = ""
        self.selectedCounty_id = ""
        self.txt_country.didSelect { selectedText, index, id in
            self.txt_country.text = selectedText
            self.selectedCounty_id = self.Country_Array[index]["id"].stringValue
            let urlString = API_URL + "state-list"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["country_id":self.selectedCounty_id,"theme_id":APP_THEME]
            self.Webservice_Statelist(url: urlString, params: params, header: headers)
        }
    }
    @IBAction func txtTap_State(_ sender: DropDown) {
        var state_Name = [String]()
        for data in self.State_Array
        {
            state_Name.append(data["name"].stringValue)
        }
        self.txt_State.textColor = .white
        self.txt_State.checkMarkEnabled = false
        self.txt_State.optionArray = state_Name
        self.txt_State.selectedRowColor = UIColor.init(named: "White_light")!
        self.txt_State.rowBackgroundColor  = UIColor.init(named: "White_light")!
        self.txt_State.itemsColor = UIColor(named: "Primary_Color")!
        self.txt_City.text = ""
        self.selectedCity_id = ""
        self.selectedState_id = ""
        self.txt_State.didSelect { selectedText, index, id in
            self.txt_State.text = selectedText
            self.selectedState_id = self.State_Array[index]["id"].stringValue
            let urlString = API_URL + "city-list"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["state_id":self.selectedState_id,"theme_id":APP_THEME]
            self.Webservice_Citylist(url: urlString, params: params, header: headers)
        }
    }
    
    @IBAction func txtTap_City(_ sender: DropDown) {
        var city_Name = [String]()
        for data in self.City_Array
        {
            city_Name.append(data["name"].stringValue)
        }
        self.txt_City.textColor = .white
        self.txt_City.checkMarkEnabled = false
        self.txt_City.optionArray = city_Name
        self.txt_City.selectedRowColor = UIColor.init(named: "White_light")!
        self.txt_City.rowBackgroundColor  = UIColor.init(named: "White_light")!
        self.txt_City.itemsColor = UIColor(named: "Primary_Color")!
        self.selectedCity_id = ""
        self.txt_City.didSelect { selectedText, index, id in
            self.txt_City.text = selectedText
            self.selectedCity_id = self.City_Array[index]["id"].stringValue
        }
    }
    
    @IBAction func txtTap_delivery_Country(_ sender: DropDown) {
        var country_Name = [String]()
        for data in Country_Delivery_Array
        {
            country_Name.append(data["name"].stringValue)
        }
        self.txt_delivery_country.textColor = .white
        self.txt_delivery_country.checkMarkEnabled = false
        self.txt_delivery_country.optionArray = country_Name
        self.txt_delivery_country.selectedRowColor = UIColor.init(named: "White_light")!
        self.txt_delivery_country.rowBackgroundColor  = UIColor.init(named: "White_light")!
        self.txt_delivery_country.itemsColor = UIColor(named: "Primary_Color")!
        self.txt_delivery_State.text = ""
        self.txt_delivery_City.text = ""
        self.selectedCity_Delivery_id = ""
        self.selectedState_Delivery_id = ""
        self.selectedCounty_Delivery_id = ""
        self.txt_delivery_country.didSelect { selectedText, index, id in
            self.txt_delivery_country.text = selectedText
            self.selectedCounty_Delivery_id = self.Country_Delivery_Array[index]["id"].stringValue
            let urlString = API_URL + "state-list"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["country_id":self.selectedCounty_Delivery_id,"theme_id":APP_THEME]
            self.Webservice_Statelist(url: urlString, params: params, header: headers)
        }
    }
    @IBAction func txtTap_delivery_State(_ sender: DropDown) {
        var state_Name = [String]()
        for data in self.State_Delivery_Array
        {
            state_Name.append(data["name"].stringValue)
        }
        self.txt_delivery_State.textColor = .white
        self.txt_delivery_State.checkMarkEnabled = false
        self.txt_delivery_State.optionArray = state_Name
        self.txt_delivery_State.selectedRowColor = UIColor.init(named: "White_light")!
        self.txt_delivery_State.rowBackgroundColor  = UIColor.init(named: "White_light")!
        self.txt_delivery_State.itemsColor = UIColor(named: "Primary_Color")!
        self.txt_delivery_City.text = ""
        self.selectedCity_Delivery_id = ""
        self.selectedState_Delivery_id = ""
        self.txt_delivery_State.didSelect { selectedText, index, id in
            self.txt_delivery_State.text = selectedText
            self.selectedState_Delivery_id = self.State_Delivery_Array[index]["id"].stringValue
            let urlString = API_URL + "city-list"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["state_id":self.selectedState_Delivery_id,"theme_id":APP_THEME]
            self.Webservice_Citylist(url: urlString, params: params, header: headers)
        }
        
    }
    
    @IBAction func txtTap_delivery_City(_ sender: DropDown) {
        var city_Name = [String]()
        for data in self.City_Delivery_Array
        {
            city_Name.append(data["name"].stringValue)
        }
        self.txt_delivery_City.textColor = .white
        self.txt_delivery_City.checkMarkEnabled = false
        self.txt_delivery_City.optionArray = city_Name
        self.txt_delivery_City.selectedRowColor = UIColor.init(named: "White_light")!
        self.txt_delivery_City.rowBackgroundColor  = UIColor.init(named: "White_light")!
        self.txt_delivery_City.itemsColor = UIColor(named: "Primary_Color")!
        self.selectedCity_Delivery_id = ""
        self.txt_delivery_City.didSelect { selectedText, index, id in
            self.txt_delivery_City.text = selectedText
            self.selectedCity_Delivery_id = self.City_Delivery_Array[index]["id"].stringValue
        }
    }
    @IBAction func btnTap_continue(_ sender: UIButton) {
        if self.txt_firstName.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: FIRST_MESSAGE)
        }
        else if self.txt_LastName.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: LASTNAME_MESSAGE)
        }
        if self.txt_Email.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: EMAIL_MESSAGE)
        }
        else if self.txt_Telephone.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: PHONE_MESSAGE)
        }
        else if isValidateEmail(email: self.txt_Email.text!) == false
        {
            showAlertMessage(titleStr: "", messageStr: VALID_EMAIL_MESSAGE)
        }
        else if isValidateEmail(email: self.txt_Email.text!) == false
        {
            showAlertMessage(titleStr: "", messageStr: VALID_EMAIL_MESSAGE)
        }
        else if self.txt_Address1.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: ENTER_ADDRESS_MESAAGE)
        }
        
        else if self.txt_country.text == ""
        {
            showAlertMessage(titleStr: "", messageStr: ENTER_COUNTRY_MESAAGE)
        }
        else if self.txt_State.text == ""
        {
            showAlertMessage(titleStr: "", messageStr: ENTER_STATE_MESAAGE)
        }
        else if self.txt_City.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: ENTER_CITY_MESAAGE)
        }
        else if self.txt_Postcode.text! == ""
        {
            showAlertMessage(titleStr: "", messageStr: ENTER_POSTCODE_MESAAGE)
        }
        else if self.txt_Postcode.text!.count != 6
        {
            showAlertMessage(titleStr: "", messageStr: VALID_POSTCODE_MESSAGE)
        }
        else{
            
            if self.btn_check.imageView?.image == UIImage.init(systemName: "checkmark.square.fill")
            {
                UserDefaultManager.setStringToUserDefaults(value: self.txt_country.text!, key: UD_SelectedCountry)
                UserDefaultManager.setStringToUserDefaults(value: self.txt_State.text!, key: UD_SelectedState)
                
                UserDefaultManager.setStringToUserDefaults(value: self.txt_country.text!, key: UD_SelectedCountry_Delivery)
                UserDefaultManager.setStringToUserDefaults(value: self.txt_State.text!, key: UD_SelectedState_Delivery)
                
                let billingObj = ["firstname":self.txt_firstName.text!,"lastname":self.txt_LastName.text!,"email":self.txt_Email.text!,"billing_user_telephone":self.txt_Telephone.text!,"billing_address":self.txt_Address1.text!,"billing_postecode":self.txt_Postcode.text!,"billing_country":self.selectedCounty_id,"billing_state":self.selectedState_id,"billing_city":self.txt_City.text!,"delivery_address":self.txt_Address1.text!,"delivery_postcode":self.txt_Postcode.text!,"delivery_country":self.selectedCounty_id,"delivery_state":self.selectedState_id,"delivery_city":self.txt_City.text!]
                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: billingObj, key: UD_BillingObj)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectDeliveryVC") as! SelectDeliveryVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                if self.txt_Delivery_Address1.text! == ""
                {
                    showAlertMessage(titleStr: "", messageStr: ENTER_DELIVERY_ADDRESS_MESAAGE)
                }
                else if self.txt_delivery_country.text == ""
                {
                    showAlertMessage(titleStr: "", messageStr: ENTER_DELIVERY_COUNTRY_MESAAGE)
                }
                else if self.txt_delivery_State.text == ""
                {
                    showAlertMessage(titleStr: "", messageStr: ENTER_DELIVERY_STATE_MESAAGE)
                }
                else if self.txt_delivery_City.text! == ""
                {
                    showAlertMessage(titleStr: "", messageStr: ENTER_DELIVERY_CITY_MESAAGE)
                }
                else if self.txt_Delivery_Postcode.text! == ""
                {
                    showAlertMessage(titleStr: "", messageStr: ENTER_DELIVERY_POSTCODE_MESAAGE)
                }
                else if self.txt_Delivery_Postcode.text!.count != 6
                {
                    showAlertMessage(titleStr: "", messageStr: VALID_POSTCODE_MESSAGE)
                }
                else
                {
                    UserDefaultManager.setStringToUserDefaults(value: self.txt_country.text!, key: UD_SelectedCountry)
                    UserDefaultManager.setStringToUserDefaults(value: self.txt_State.text!, key: UD_SelectedState)
                    
                    UserDefaultManager.setStringToUserDefaults(value: self.txt_delivery_country.text!, key: UD_SelectedCountry_Delivery)
                    UserDefaultManager.setStringToUserDefaults(value: self.txt_delivery_State.text!, key: UD_SelectedState_Delivery)
                    
                    let billingObj = ["firstname":self.txt_firstName.text!,"lastname":self.txt_LastName.text!,"email":self.txt_Email.text!,"billing_user_telephone":self.txt_Telephone.text!,"billing_address":self.txt_Address1.text!,"billing_postecode":self.txt_Postcode.text!,"billing_country":self.selectedCounty_id,"billing_state":self.selectedState_id,"billing_city":self.txt_City.text!,"delivery_address":self.txt_Delivery_Address1.text!,"delivery_postcode":self.txt_Delivery_Postcode.text!,"delivery_country":self.selectedCounty_Delivery_id,"delivery_state":self.selectedState_Delivery_id,"delivery_city":self.txt_delivery_City.text!]
                    UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: billingObj, key: UD_BillingObj)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectDeliveryVC") as! SelectDeliveryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
extension Guest_BillingDetailsVC
{
    func Webservice_Countrylist(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                self.Country_Array = jsonResponse!["data"].arrayValue
                self.Country_Delivery_Array = jsonResponse!["data"].arrayValue
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
            else{
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    
    func Webservice_Statelist(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                self.State_Array = jsonResponse!["data"].arrayValue
                self.State_Delivery_Array = jsonResponse!["data"].arrayValue
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
            else{
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    
    func Webservice_Citylist(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                self.City_Array = jsonResponse!["data"].arrayValue
                self.City_Delivery_Array = jsonResponse!["data"].arrayValue
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
            else{
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
}

