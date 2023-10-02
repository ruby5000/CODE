
import UIKit
import SwiftyJSON

class NewWishlistVC: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var Tableview_Wishlist: UITableView!
    @IBOutlet weak var lbl_Nodata: UILabel!
    @IBOutlet weak var lbl_count: UILabel!
    var pageIndex = 1
    var lastIndex = 0
    var Wishlist_Array = [[String:String]]()
    var product_id = String()
    var Selected_Variant_id = String()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cornerRadius(viewName: self.lbl_count, radius: self.lbl_count.frame.height / 2)
        self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            keyWindow?.rootViewController = nav
        }
        else{
            self.pageIndex = 1
            self.lastIndex = 0
            let urlString = API_URL + "wishlist-list?page=\(self.pageIndex)"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
            self.Webservice_Wishlistdata(url: urlString, params: params, header: headers)
        }
    }
    
}
extension NewWishlistVC
{
    @IBAction func btnTap_Cart(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Tableview Methods
extension NewWishlistVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Wishlist_Array.count == 0
        {
            self.lbl_Nodata.isHidden = false
        }
        else{
            self.lbl_Nodata.isHidden = true
        }
        return self.Wishlist_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.Tableview_Wishlist.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell
        let data = Wishlist_Array[indexPath.row]
        let ItemPrice = formatter.string(for: data["final_price"]!.toDouble)
        cell.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
        cell.img_products.sd_setImage(with: URL(string: IMG_URL + data["product_image"]!), placeholderImage: UIImage(named: ""))
        
        let original3 = IMG_URL + data["product_image"]!
        if let encoded = original3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encoded)
        {
            cell.img_products.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
        
        cell.lbl_name.text = data["product_name"]!
        cell.lbl_size.text = data["variant_name"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let cartAction = UIContextualAction(
            style: .normal,
            title:  nil,
            handler: { (_, _, success: (Bool) -> Void) in
                success(true)
                let data = self.Wishlist_Array[indexPath.row]
                self.product_id = data["product_id"]!
                self.Selected_Variant_id = data["variant_id"]!
                
                let urlString = API_URL + "addtocart"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"variant_id":data["variant_id"]!,"qty":"1","product_id":data["product_id"]!,"theme_id":APP_THEME]
                self.Webservice_Cart(url: urlString, params: params, header: headers)
            }
        )
        cartAction.image = UISwipeActionsConfiguration.makeTitledImage(
            image: UIImage(named: "ic_cartwish"),
            title: "")
        cartAction.backgroundColor = UIColor.init(named: "light_Color")
        
        return UISwipeActionsConfiguration(actions: [cartAction])
    }
    
    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(
            style: .normal,
            title:  nil,
            handler: { (_, _, success: (Bool) -> Void) in
                success(true)
                let data = self.Wishlist_Array[indexPath.row]
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                // quantity_type :- increase | decrease | remove (remove from cart)
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["product_id"]!,"wishlist_type":"remove","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers)
            }
        )
        deleteAction.image = UISwipeActionsConfiguration.makeTitledImage(
            image: UIImage(named: "ic_trash"),
            title: "")
        deleteAction.backgroundColor = UIColor.init(named: "light_Color")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.Wishlist_Array[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(identifier: "ItemDetailsVC") as! ItemDetailsVC
        vc.item_id = data["product_id"]!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath)
    {
        if indexPath.item == self.Wishlist_Array.count - 1 {
            if self.pageIndex != self.lastIndex {
                self.pageIndex = self.pageIndex + 1
                if self.Wishlist_Array.count != 0 {
                    let urlString = API_URL + "wishlist-list?page=\(self.pageIndex)"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
                    self.Webservice_Wishlistdata(url: urlString, params: params, header: headers)
                }
            }
        }
    }
}
extension NewWishlistVC
{
    func Webservice_Wishlistdata(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                if self.pageIndex == 1 {
                    self.lastIndex = Int(jsondata["last_page"]!.stringValue)!
                    self.Wishlist_Array.removeAll()
                }
                let Featuredprodcutdata = jsondata["data"]!.arrayValue
                for data in Featuredprodcutdata
                {
                    let productObj = ["id":data["id"].stringValue,"product_name":data["product_name"].stringValue,"product_image":data["product_image"].stringValue,"variant_name":data["variant_name"].stringValue,"final_price":data["final_price"].stringValue,"product_id":data["product_id"].stringValue,"variant_id":data["variant_id"].stringValue]
                    self.Wishlist_Array.append(productObj)
                }
                self.Tableview_Wishlist.delegate = self
                self.Tableview_Wishlist.dataSource = self
                self.Tableview_Wishlist.reloadData()
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
    func Webservice_wishlist(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                self.pageIndex = 1
                self.lastIndex = 0
                let urlString = API_URL + "wishlist-list?page=\(self.pageIndex)"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
                self.Webservice_Wishlistdata(url: urlString, params: params, header: headers)
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
    func Webservice_Cart(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                //showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
                UserDefaultManager.setStringToUserDefaults(value: jsonResponse!["data"]["count"].stringValue, key: UD_CartCount)
                self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
                
                let alert = UIAlertController(title: nil, message: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"), preferredStyle: .alert)
                let ContinueAction = UIAlertAction(title: "Continue shopping", style: .default) { (action) in
                    self.dismiss(animated: true)
                }
                
                let ProceedAction = UIAlertAction(title: "Proceed to check out", style: .default) { (action) in
                    let vc = self.storyboard?.instantiateViewController(identifier: "CartVC") as! CartVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                alert.addAction(ContinueAction)
                alert.addAction(ProceedAction)
                self.present(alert, animated: true, completion: nil)
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
            else if status == "0"
            {
                let alertVC = UIAlertController(title: Bundle.main.displayName!, message: ALREADYCART_CONFIRM_MESSAGE, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    
                    let urlString = API_URL + "cart-qty"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    // quantity_type :- increase | decrease | remove (remove from cart)
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":self.product_id,"variant_id":self.Selected_Variant_id,"quantity_type":"increase","theme_id":APP_THEME]
                    self.Webservice_CartQty(url: urlString, params: params, header: headers)
                    
                }
                
                let noAction = UIAlertAction(title: "No", style: .destructive)
                alertVC.addAction(noAction)
                alertVC.addAction(yesAction)
                self.present(alertVC,animated: true,completion: nil)
            }
            else
            {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    func Webservice_CartQty(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                UserDefaultManager.setStringToUserDefaults(value: jsonResponse!["count"].stringValue, key: UD_CartCount)
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

