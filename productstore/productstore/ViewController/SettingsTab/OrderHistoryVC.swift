
import UIKit
import SwiftyJSON

class orderhistorycell : UITableViewCell
{
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_orderNo: UILabel!
    @IBOutlet weak var lbl_order: UILabel!
}
class OrderHistoryVC: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
    @IBOutlet weak var Tableview_Orderhistory: UITableView!
    @IBOutlet weak var lbl_Nodata: UILabel!
    @IBOutlet weak var Scroll_View: UIScrollView!
    
    var OrderHistory_Array = [[String:String]]()
    var pageIndex = 1
    var lastIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Scroll_View.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageIndex = 1
        self.lastIndex = 0
        let urlString = API_URL + "order-list?page=\(self.pageIndex)"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
        self.Webservice_OrderHistory(url: urlString, params: params, header: headers)
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
extension OrderHistoryVC
{
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: Tableview Methods
extension OrderHistoryVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.OrderHistory_Array.count == 0
        {
            self.lbl_Nodata.isHidden = false
        }
        else{
            self.lbl_Nodata.isHidden = true
        }
        return self.OrderHistory_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.Tableview_Orderhistory.dequeueReusableCell(withIdentifier: "orderhistorycell") as! orderhistorycell
        let data = self.OrderHistory_Array[indexPath.row]
        cell.lbl_orderNo.text = "#\(data["order_id"]!)"
        cell.lbl_status.text = "Status: \(data["order_status"]!)"
        let ItemPrice = formatter.string(for: data["amount"]!.toDouble)
        cell.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
        let dates = DateFormater.getFullDateStringFromString(givenDate: data["date"]!)
        cell.lbl_date.text = "Date:\(dates)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.OrderHistory_Array[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderhistoryDetailsVC") as! OrderhistoryDetailsVC
        vc.order_id = data["id"]!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension OrderHistoryVC
{
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
                    let productObj = ["id":data["id"].stringValue,"date":data["date"].stringValue,"order_id":data["product_order_id"].stringValue,"order_status":data["delivered_status_string"].stringValue,"amount":data["amount"].stringValue]
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
