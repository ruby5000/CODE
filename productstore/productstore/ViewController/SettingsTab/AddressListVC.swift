//
//  AddressListVC.swift
//  Fashion
//
//  Created by Gravityinfotech on 05/08/22.
//

import UIKit
import SwiftyJSON

class AddressListVC: UIViewController {
    
    @IBOutlet weak var Height_Address: NSLayoutConstraint!
    @IBOutlet weak var Tableview_AddressList: UITableView!
    @IBOutlet weak var Scroll_View: UIScrollView!
    @IBOutlet weak var lbl_Nodata: UILabel!
    
    var selectedindex = 0
    var pageIndex = 1
    var lastIndex = 0
    var AddressList_Array = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Scroll_View.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageIndex = 1
        self.lastIndex = 0
        let urlString = API_URL + "address-list"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
        self.Webservice_AddressList(url: urlString, params: params, header: headers)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (Int(self.Scroll_View.contentOffset.y) >=  Int(self.Scroll_View.contentSize.height - self.Scroll_View.frame.size.height)) {
            if self.pageIndex != self.lastIndex {
                self.pageIndex = self.pageIndex + 1
                if self.AddressList_Array.count != 0 {
                    let urlString = API_URL + "address-list?page=\(self.pageIndex)"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
                    self.Webservice_AddressList(url: urlString, params: params, header: headers)
                }
            }
        }
    }
    
}
//MARK: Tableview Methods
extension AddressListVC
{
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_AddAddress(_ sender: UIButton) {
        let vc = MainstoryBoard.instantiateViewController(withIdentifier: "AddaddressVC") as! AddaddressVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Tableview Methods
extension AddressListVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.AddressList_Array.count == 0
        {
            self.lbl_Nodata.isHidden = false
        }
        else{
            self.lbl_Nodata.isHidden = true
        }
        return self.AddressList_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.Tableview_AddressList.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell
        let data = self.AddressList_Array[indexPath.row]
        cell.lbl_title.text = data["title"]!
        var cityName = String()
        if data["city_name"]! == ""
        {
            cityName = data["city_id"]!
        }
        else{
            cityName = data["city_name"]!
        }
        cell.lbl_desc.text = "\(data["address"]!), \(cityName) , \(data["state_name"]!), \(data["country_name"]!) - \(data["postcode"]!)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedindex = indexPath.item
        self.Tableview_AddressList.reloadData()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(
            style: .normal,
            title:  nil,
            handler: { (_, _, success: (Bool) -> Void) in
                success(true)
                let data = self.AddressList_Array[indexPath.row]
                let urlString = API_URL + "delete-address"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                // quantity_type :- increase | decrease | remove (remove from cart)
                let params: NSDictionary = ["address_id":data["id"]!,"theme_id":APP_THEME]
                self.Webservice_DeleteAddressList(url: urlString, params: params, header: headers)
            }
        )
        let EditAction = UIContextualAction(
            style: .normal,
            title:  nil,
            handler: { (_, _, success: (Bool) -> Void) in
                success(true)
                let data = self.AddressList_Array[indexPath.row]
                let vc = MainstoryBoard.instantiateViewController(withIdentifier: "AddaddressVC") as! AddaddressVC
                vc.isedit = "1"
                vc.EditAddress_Data = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        )
        
        EditAction.image = UISwipeActionsConfiguration.makeTitledImage(
            image: UIImage(named: "ic_show"),
            title: "")
        EditAction.backgroundColor = UIColor.init(named: "White_light")!
        
        
        deleteAction.image = UISwipeActionsConfiguration.makeTitledImage(
            image: UIImage(named: "ic_trash"),
            title: "")
        deleteAction.backgroundColor = UIColor.init(named: "White_light")!
        
        return UISwipeActionsConfiguration(actions: [deleteAction,EditAction])
    }
    
}
extension AddressListVC
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
                    let productObj = ["id":data["id"].stringValue,"country_id":data["country_id"].stringValue,"state_id":data["state_id"].stringValue,"city_name":data["city_name"].stringValue,"city_id":data["city_id"].stringValue,"title":data["title"].stringValue,"address":data["address"].stringValue,"postcode":data["postcode"].stringValue,"default_address":data["default_address"].stringValue,"country_name":data["country_name"].stringValue,"state_name":data["state_name"].stringValue]
                    self.AddressList_Array.append(productObj)
                }
                
                self.Tableview_AddressList.delegate = self
                self.Tableview_AddressList.dataSource = self
                self.Tableview_AddressList.reloadData()
                self.Height_Address.constant = CGFloat(self.AddressList_Array.count * 100)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.Height_Address.constant = self.Tableview_AddressList.contentSize.height
                }
                
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
    func Webservice_DeleteAddressList(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let urlString = API_URL + "address-list"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
                self.Webservice_AddressList(url: urlString, params: params, header: headers)
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
