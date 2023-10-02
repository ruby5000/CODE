
import UIKit
import SwiftyJSON
import SDWebImage

class MyReturnsVC: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
    @IBOutlet weak var Tableview_Orderhistory: UITableView!
    @IBOutlet weak var lbl_Nodata: UILabel!
    @IBOutlet weak var Scroll_View: UIScrollView!
    
    var pageIndex = 1
    var lastIndex = 0
    var OrderReturn_Array = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Scroll_View.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageIndex = 1
        self.lastIndex = 0
        let urlString = API_URL + "return-order-list?page=\(self.pageIndex)"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
        print(headers)
        self.Webservice_ReturnOderList(url: urlString, params: params, header: headers)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (Int(self.Scroll_View.contentOffset.y) >=  Int(self.Scroll_View.contentSize.height - self.Scroll_View.frame.size.height)) {
            if self.pageIndex != self.lastIndex {
                self.pageIndex = self.pageIndex + 1
                if self.OrderReturn_Array.count != 0 {
                    let urlString = API_URL + "return-order-list?page=\(self.pageIndex)"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
                    print(headers)
                    self.Webservice_ReturnOderList(url: urlString, params: params, header: headers)
                }
            }
        }
    }
}
//MARK: Button Action
extension MyReturnsVC
{
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: Tableview Methods
extension MyReturnsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.OrderReturn_Array.count == 0
        {
            self.lbl_Nodata.isHidden = false
        }
        else{
            self.lbl_Nodata.isHidden = true
        }
        return self.OrderReturn_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.Tableview_Orderhistory.dequeueReusableCell(withIdentifier: "orderhistorycell") as! orderhistorycell
        let data = self.OrderReturn_Array[indexPath.row]
        cell.lbl_orderNo.text = data["order_id_string"]!
        cell.lbl_status.text = "Status: \(data["delivered_status_string"]!)"
        let ItemPrice = formatter.string(for: data["amount"]!.toDouble)
        cell.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
        let dates = DateFormater.getFullDateStringFromString(givenDate: data["date"]!)
        cell.lbl_date.text = "Date:\(dates)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.OrderReturn_Array[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderhistoryDetailsVC") as! OrderhistoryDetailsVC
        vc.order_id = data["id"]!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MyReturnsVC
{
    func Webservice_ReturnOderList(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                if self.pageIndex == 1 {
                    self.lastIndex = Int(jsondata["last_page"]!.stringValue)!
                    self.OrderReturn_Array.removeAll()
                }
                let Historydata = jsondata["data"]!.arrayValue
                for data in Historydata
                {
                    let productObj = ["id":data["id"].stringValue,"date":data["date"].stringValue,"order_id_string":data["order_id_string"].stringValue,"delivered_status_string":data["delivered_status_string"].stringValue,"amount":data["amount"].stringValue]
                    self.OrderReturn_Array.append(productObj)
                }
                
                self.Tableview_Orderhistory.delegate = self
                self.Tableview_Orderhistory.dataSource = self
                self.Tableview_Orderhistory.reloadData()
                self.Height_Tableview.constant = CGFloat(90 * self.OrderReturn_Array.count)
                
            }
            else if status == "9"
            {
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
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
