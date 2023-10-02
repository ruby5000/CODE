//
//  BillingDetailsVC.swift
//  Fashion
//
//  Created by Gravityinfotech on 25/03/22.
//

import UIKit
import SwiftyJSON
import iOSDropDown

class BillingDetailsVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Telephone: UITextField!
    var pageIndex = 1
    var lastIndex = 0
    var selectedindex = 0
    var AddressList_Array = [[String:String]]()
    
    @IBOutlet weak var txt_Address1: UITextField!
    @IBOutlet weak var txt_State: DropDown!
    @IBOutlet weak var txt_country: DropDown!
    @IBOutlet weak var txt_City: DropDown!
    @IBOutlet weak var txt_Postcode: UITextField!
    var selectedCounty_id = String()
    var selectedState_id = String()
    var selectedCity_id = String()
    var Country_Array = [JSON]()
    var State_Array = [JSON]()
    var City_Array = [JSON]()
    
    @IBOutlet weak var Height_DeliveryView: NSLayoutConstraint!
    @IBOutlet weak var View_Delivery: UIView!
    @IBOutlet weak var btn_AddNewaddress: UIButton!
    @IBOutlet weak var Tableview_Height: NSLayoutConstraint!
    @IBOutlet weak var Tableview_AddressList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_Postcode.delegate = self
        self.View_Delivery.isHidden = true
        self.Height_DeliveryView.constant = 0.0
        self.btn_check.setImage(UIImage.init(systemName: "checkmark.square.fill"), for: .normal)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 6 //Here 6 is your character limit
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.Tableview_AddressList.estimatedRowHeight = 90
        self.Tableview_Height.constant = 90
        self.txt_Email.text = UserDefaultManager.getStringFromUserDefaults(key: UD_emailId)
        self.txt_Telephone.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userPhone)
        self.txt_LastName.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userLastName)
        self.txt_firstName.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userFirstName)
        
        self.pageIndex = 1
        self.lastIndex = 0
        let urlString = API_URL + "address-list"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
        self.Webservice_AddressList(url: urlString, params: params, header: headers)
    }
}
//MARK: Button Actions
extension BillingDetailsVC
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

    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTap_AddNewaddress(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddaddressVC") as! AddaddressVC
        self.navigationController?.pushViewController(vc, animated: true)
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
        else if self.txt_Email.text! == ""
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
        else{
            if self.AddressList_Array.count != 0
            {
        //      let data = self.AddressList_Array[selectedindex]
                if self.btn_check.imageView?.image == UIImage.init(systemName: "checkmark.square.fill")
                {
                    let data = self.AddressList_Array[selectedindex]
                    UserDefaultManager.setStringToUserDefaults(value: self.txt_Telephone.text!, key: UD_userPhone)
                    UserDefaultManager.setStringToUserDefaults(value: self.txt_LastName.text!, key: UD_userLastName)
                    
                    var cityName = String()
                    if data["city"]! == ""
                    {
                        cityName = data["city_id"]!
                    }
                    else{
                        cityName = data["city"]!
                    }
                    let billingObj = ["firstname":self.txt_firstName.text!,"lastname":self.txt_LastName.text!,"email":self.txt_Email.text!,"billing_user_telephone":self.txt_Telephone.text!,"billing_address":data["address"]!,"billing_postecode":data["postcode"]!,"billing_country":data["country_id"]!,"billing_state":data["state_id"]!,"billing_city":cityName,"delivery_address":data["address"]!,"delivery_postcode":data["postcode"]!,"delivery_country":data["country_id"]!,"delivery_state":data["state_id"]!,"delivery_city":cityName]
                    UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: billingObj, key: UD_BillingObj)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectDeliveryVC") as! SelectDeliveryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else{
                    let data = self.AddressList_Array[selectedindex]
                    if self.txt_Address1.text! == ""
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
                        UserDefaultManager.setStringToUserDefaults(value: self.txt_Telephone.text!, key: UD_userPhone)
                        UserDefaultManager.setStringToUserDefaults(value: self.txt_LastName.text!, key: UD_userLastName)
                        var cityName = String()
                        if data["city"]! == ""
                        {
                            cityName = data["city_id"]!
                        }
                        else{
                            cityName = data["city"]!
                        }
                        
                        let billingObj = ["firstname":self.txt_firstName.text!,"lastname":self.txt_LastName.text!,"email":self.txt_Email.text!,"billing_user_telephone":self.txt_Telephone.text!,"billing_address":data["address"]!,"billing_postecode":data["postcode"]!,"billing_country":data["country_id"]!,"billing_state":data["state_id"]!,"billing_city":cityName,"delivery_address":self.txt_Address1.text!,"delivery_postcode":self.txt_Postcode.text!,"delivery_country":self.selectedCounty_id,"delivery_state":self.selectedState_id,"delivery_city":self.txt_City.text!]
                        UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: billingObj, key: UD_BillingObj)
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectDeliveryVC") as! SelectDeliveryVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            }
            else{
                showAlertMessage(titleStr: "", messageStr: SELECT_ADDRESS_MESAAGE)
            }
            
        }
        
    }
}
//MARK: Tableview Methods
extension BillingDetailsVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AddressList_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.Tableview_AddressList.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell
        if indexPath.row == self.selectedindex
        {
            setBorder(viewName: cell.cell_view, borderwidth: 1.5, borderColor: UIColor.init(named: "White_light")!.cgColor, cornerRadius: 10)
            cell.img_selected.image = UIImage(named: "ic_checkfill")
        }
        else
        {
            setBorder(viewName: cell.cell_view, borderwidth: 1.5, borderColor: UIColor.lightGray.cgColor, cornerRadius: 10)
            cell.img_selected.image = UIImage(named: "ic_check")
        }
        
        let data = self.AddressList_Array[indexPath.row]
        cell.lbl_title.text = data["title"]!
        var cityName = String()
        if data["city"]! == ""
        {
            cityName = data["city_id"]!
        }
        else{
            cityName = data["city"]!
        }
        cell.lbl_desc.text = "\(data["address"]!), \(cityName), \(data["state_name"]!), \(data["country_name"]!) - \(data["postcode"]!)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedindex = indexPath.item
        self.Tableview_AddressList.reloadData()
    }
}
extension BillingDetailsVC
{
    func Webservice_AddressList(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                if self.pageIndex == 1 {
                    self.lastIndex = Int(jsondata["last_page"]!.stringValue)!
                    self.AddressList_Array.removeAll()
                }
                let Array_data = jsondata["data"]!.arrayValue
                for data in Array_data
                {
                    let productObj = ["id":data["id"].stringValue,"country_id":data["country_id"].stringValue,"state_id":data["state_id"].stringValue,"city":data["city_name"].stringValue,"title":data["title"].stringValue,"address":data["address"].stringValue,"postcode":data["postcode"].stringValue,"default_address":data["default_address"].stringValue,"country_name":data["country_name"].stringValue,"state_name":data["state_name"].stringValue,"city_id":data["city_id"].stringValue]
                    self.AddressList_Array.append(productObj)
                }
                self.Tableview_AddressList.delegate = self
                self.Tableview_AddressList.dataSource = self
                self.Tableview_AddressList.reloadData()
                self.Tableview_Height.constant = CGFloat(90 * self.AddressList_Array.count)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.Tableview_Height.constant = self.Tableview_AddressList.contentSize.height
                }
                let urlString = API_URL + "country-list"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["theme_id":APP_THEME]
                self.Webservice_Countrylist(url: urlString, params: params, header: headers)
                
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
