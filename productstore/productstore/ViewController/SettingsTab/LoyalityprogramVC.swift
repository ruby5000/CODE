
import UIKit
import SwiftyJSON

class LoyalityprogramVC: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
    @IBOutlet weak var Tableview_Orderhistory: UITableView!
    @IBOutlet weak var Scroll_View: UIScrollView!
    @IBOutlet weak var lbl_loyality_program_title: UILabel!
    @IBOutlet weak var lbl_loyality_program_description: UILabel!
    @IBOutlet weak var lbl_loyality_program_your_cash: UILabel!
    @IBOutlet weak var lbl_loyality_program_copy_this_link_and_send_to_your_friends: UILabel!
    @IBOutlet weak var lbl_link: UILabel!
    
    var string_point = String()
    var pageIndex = 1
    var lastIndex = 0
    var OrderHistory_Array = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_link.text = IMG_URL
        self.Scroll_View.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let urlString = API_URL + "loyality-program-json"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["theme_id":APP_THEME]
        print(headers)
        self.Webservice_LoyalityProgramJson(url: urlString, params: params, header: headers)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (Int(self.Scroll_View.contentOffset.y) >=  Int(self.Scroll_View.contentSize.height - self.Scroll_View.frame.size.height)) {
            if self.pageIndex != self.lastIndex {
                self.pageIndex = self.pageIndex + 1
                if self.OrderHistory_Array.count != 0 {
                    let urlString = API_URL + "order-list?page=\(self.pageIndex)"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
                    self.Webservice_OrderHistory(url: urlString, params: params, header: headers)
                }
            }
        }
    }
}
//MARK: Button Action
extension LoyalityprogramVC
{
    @IBAction func btnTap_Copy(_ sender: UIButton) {
        UIPasteboard.general.string = self.lbl_link.text
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr:"Link copied!")
    }
    
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: Tableview Methods
extension LoyalityprogramVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderHistory_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.Tableview_Orderhistory.dequeueReusableCell(withIdentifier: "orderhistorycell") as! orderhistorycell
        let data = self.OrderHistory_Array[indexPath.row]
        cell.lbl_orderNo.text = "#\(data["order_id"]!)"
        cell.lbl_status.text = "Status: \(data["order_status"]!)"
        cell.lbl_price.text = "+\(data["reward_points"]!) \(UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name)) "
        let dates = DateFormater.getFullDateStringFromString(givenDate: data["date"]!)
        cell.lbl_date.text = "Date:\(dates)"
        return cell
    }
    
}
extension LoyalityprogramVC
{
    func Webservice_LoyalityProgramJson(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let data = jsonResponse!["data"]["loyality-program"].dictionaryValue
                self.lbl_loyality_program_title.text = data["loyality-program-title"]!.stringValue
                self.lbl_loyality_program_description.text = data["loyality-program-description"]!.stringValue
                self.string_point = data["loyality-program-your-cash"]!.stringValue
                self.lbl_loyality_program_your_cash.text = self.string_point
                self.lbl_loyality_program_copy_this_link_and_send_to_your_friends.text = data["loyality-program-copy-this-link-and-send-to-your-friends"]!.stringValue
                
                let urlString = API_URL + "loyality-reward"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
                print(headers)
                self.Webservice_LoyalityReward(url: urlString, params: params, header: headers)
                
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
    func Webservice_LoyalityReward(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                self.lbl_loyality_program_your_cash.text = "\(self.string_point) : +\(jsonResponse!["data"]["point"].stringValue) \(UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name))"
                
                self.pageIndex = 1
                self.lastIndex = 0
                let urlString = API_URL + "order-list?page=\(self.pageIndex)"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
                self.Webservice_OrderHistory(url: urlString, params: params, header: headers)
                
                
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
                self.lbl_loyality_program_your_cash.text = "\(self.string_point) : +0.00"
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    func Webservice_OrderHistory(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                if self.pageIndex == 1 {
                    self.lastIndex = Int(jsondata["last_page"]!.stringValue)!
                    self.OrderHistory_Array.removeAll()
                }
                let Historydata = jsondata["data"]!.arrayValue
                for data in Historydata
                {
                    let productObj = ["id":data["id"].stringValue,"date":data["date"].stringValue,"order_id":data["product_order_id"].stringValue,"order_status":data["delivered_status_string"].stringValue,"amount":data["amount"].stringValue,"reward_points":data["reward_points"].stringValue]
                    self.OrderHistory_Array.append(productObj)
                }
                self.Tableview_Orderhistory.delegate = self
                self.Tableview_Orderhistory.dataSource = self
                self.Tableview_Orderhistory.reloadData()
                self.Height_Tableview.constant = CGFloat(90 * self.OrderHistory_Array.count)
                
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
