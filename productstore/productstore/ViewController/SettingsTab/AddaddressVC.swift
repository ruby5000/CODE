//
//  AddaddressVC.swift
//  Fashion
//
//  Created by Gravityinfotech on 28/03/22.
//

import UIKit
import SwiftyJSON
import iOSDropDown

class AddaddressVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txt_saveAddress: UITextField!
    @IBOutlet weak var txt_Address1: UITextField!
    @IBOutlet weak var txt_Postcode: UITextField!
    @IBOutlet weak var btn_No: UIButton!
    @IBOutlet weak var btn_Yes: UIButton!
    @IBOutlet weak var txt_State: DropDown!
    @IBOutlet weak var txt_country: DropDown!
    @IBOutlet weak var txt_City: DropDown!

    var Country_Array = [JSON]()
    var State_Array = [JSON]()
    var City_Array = [JSON]()
    var isdefault_address = String()
    var selectedCounty_id = String()
    var selectedState_id = String()
    var selectedCity_id = String()
    var isedit = String()
    var EditAddress_Data = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_Postcode.delegate = self
        if self.isedit == "1"
        {
            self.txt_saveAddress.text = EditAddress_Data["title"]!
            self.txt_Address1.text = EditAddress_Data["address"]!
            self.txt_Postcode.text = EditAddress_Data["postcode"]!
            self.txt_State.text = EditAddress_Data["state_name"]!
            self.txt_country.text = EditAddress_Data["country_name"]!
            
            self.selectedState_id = EditAddress_Data["state_id"]!
            self.selectedCounty_id = EditAddress_Data["country_id"]!
            
            if EditAddress_Data["city_name"]! == ""
            {
                self.txt_City.text = EditAddress_Data["city_id"]!
                self.selectedCity_id = ""
            }
            else{
                self.selectedCity_id = EditAddress_Data["city_id"]!
                self.txt_City.text = EditAddress_Data["city_name"]!
            }
            
            if self.EditAddress_Data["default_address"]! == "1"
            {
                self.btn_Yes.setImage(UIImage.init(named: "ic_checkfill"), for: .normal)
                self.btn_No.setImage(UIImage.init(named: "ic_check"), for: .normal)
                self.isdefault_address = "1"
            }
            else{
                self.btn_No.setImage(UIImage.init(named: "ic_checkfill"), for: .normal)
                self.btn_Yes.setImage(UIImage.init(named: "ic_check"), for: .normal)
                self.isdefault_address = "0"
            }
        }
        else{
            self.btn_Yes.setImage(UIImage.init(named: "ic_check"), for: .normal)
            self.btn_No.setImage(UIImage.init(named: "ic_checkfill"), for: .normal)
            self.isdefault_address = "0"
        }
        
        let urlString = API_URL + "country-list"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["theme_id":APP_THEME]
        self.Webservice_Countrylist(url: urlString, params: params, header: headers)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 6 //Here 6 is your character limit
    }
}
//MARK: Button Action
extension AddaddressVC
{
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTap_Save(_ sender: UIButton) {
        if self.txt_saveAddress.text == ""
        {
            showAlertMessage(titleStr: "", messageStr: ENTER_TYPE_MESAAGE)
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
        else if self.txt_City.text == ""
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
            if self.isedit == "1"
            {
                if self.selectedCity_id == ""
                {
                    self.selectedCity_id = self.txt_City.text!
                }
                let urlString = API_URL + "update-address"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"title":self.txt_saveAddress.text!,"address":self.txt_Address1.text!,"country":self.selectedCounty_id,"state":self.selectedState_id,"city":self.selectedCity_id,"postcode":self.txt_Postcode.text!,"default_address":self.isdefault_address,"address_id":self.EditAddress_Data["id"]!,"theme_id":APP_THEME]
                //1 =>yes/ 0 => no , default => 0
                self.Webservice_Addaddress(url: urlString, params: params, header: headers)
            }
            else{
                if self.selectedCity_id == ""
                {
                    self.selectedCity_id = self.txt_City.text!
                }
                let urlString = API_URL + "add-address"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"title":self.txt_saveAddress.text!,"address":self.txt_Address1.text!,"country":self.selectedCounty_id,"state":self.selectedState_id,"city":self.selectedCity_id,"postcode":self.txt_Postcode.text!,"default_address":self.isdefault_address,"theme_id":APP_THEME]
                //1 =>yes/ 0 => no , default => 0
                self.Webservice_Addaddress(url: urlString, params: params, header: headers)
            }
        }
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
    
    @IBAction func btnTap_YesDefaultAddress(_ sender: UIButton) {
        self.isdefault_address = "1"
        self.btn_Yes.setImage(UIImage.init(named: "ic_checkfill"), for: .normal)
        self.btn_No.setImage(UIImage.init(named: "ic_check"), for: .normal)
    }
    
    @IBAction func btnTap_NoDefaultAddress(_ sender: UIButton) {
        self.isdefault_address = "0"
        self.btn_Yes.setImage(UIImage.init(named: "ic_check"), for: .normal)
        self.btn_No.setImage(UIImage.init(named: "ic_checkfill"), for: .normal)
    }
    
}
extension AddaddressVC
{
    func Webservice_Addaddress(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
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
            else{
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    
    func Webservice_Countrylist(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                self.Country_Array = jsonResponse!["data"].arrayValue
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
