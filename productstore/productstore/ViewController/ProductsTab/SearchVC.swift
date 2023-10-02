
import UIKit
import SwiftyJSON
import SDWebImage

class SearchVC: UIViewController {
    @IBOutlet weak var Collectionview_SearchList: UICollectionView!
    @IBOutlet weak var lbl_searchresult: UILabel!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_example: UILabel!
    
    var pageIndex = 1
    var lastIndex = 0
    var SearchproductsArray = [[String:String]]()
    var isfilterselected = String()
    var tag = String()
    var min_price = String()
    var max_price = String()
    var rating = String()
    var example = String()
    var product_id = String()
    var Selected_Variant_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_searchresult.isHidden = true
        self.lbl_example.text = self.example
    }
}
extension SearchVC
{
    @IBAction func btnTap_Filter(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func txtTap_Search(_ sender: UITextField) {
        if self.txt_search.text == ""
        {
            self.pageIndex = 1
            self.lastIndex = 0
            self.SearchproductsArray.removeAll()
            self.Collectionview_SearchList.reloadData()
            self.lbl_searchresult.isHidden = true
        }
        else
        {
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                self.pageIndex = 1
                self.lastIndex = 0
                let urlString = API_URL + "search-guest?page=\(self.pageIndex)"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["type":"product_search","name":self.txt_search.text!,"theme_id":APP_THEME]
                self.Webservice_Searchproduct(url: urlString, params: params, header: headers)
            }
            else {
                self.pageIndex = 1
                self.lastIndex = 0
                let urlString = API_URL + "search?page=\(self.pageIndex)"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["type":"product_search","name":self.txt_search.text!,"theme_id":APP_THEME]
                self.Webservice_Searchproduct(url: urlString, params: params, header: headers)
            }
        }
    }
}
// MARK:- CollectionView Deleget methods
extension SearchVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.Collectionview_SearchList
        {
            return self.SearchproductsArray.count
        }
        else
        {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.Collectionview_SearchList
        {
            let cell = self.Collectionview_SearchList.dequeueReusableCell(withReuseIdentifier: "featuredItemListCell", for: indexPath) as! featuredItemListCell
            let data = SearchproductsArray[indexPath.item]
            cell.lbl_itemname.text = data["name"]!
            let ItemPrice = formatter.string(for: data["final_price"]!.toDouble)
            let ItemoriginalPrice = formatter.string(for: data["original_price"]!.toDouble)
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(ItemoriginalPrice!) \(UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name))")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            
            if data["discount_type"]! == "percentage" {
                cell.lbl_itemdiscountPrice.text = "\(data["discount_price"]!)%"
            }
            else {
                cell.lbl_itemdiscountPrice.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(data["discount_price"]!)"
            }
            
            cell.lbl_itemPrice.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
            let original3 = IMG_URL + data["cover_image_path"]!
            if let encoded = original3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let url = URL(string: encoded)
            {
                cell.img_item.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            }
            
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" {
                cell.btn_favrites.isHidden = true
                cell.view_likeBtnBg.isHidden = true
            }
            else {
                cell.btn_favrites.isHidden = false
                cell.view_likeBtnBg.isHidden = false
            }
            
            if data["in_whishlist"]! == "false" {
                cell.btn_favrites.setImage(UIImage.init(named: "ic_hart"), for: .normal)
            }
            else if data["in_whishlist"]! == "true" {
                cell.btn_favrites.setImage(UIImage.init(named: "ic_hartfill"), for: .normal)
            }
            
           cell.lbl_rating.text = "\(data["average_rating"]!).0 / 5.0"
           cell.CosmosViews.rating = Double(data["average_ratings"]!)!
            
            cell.btn_favrites.tag = indexPath.row
            cell.btn_favrites.addTarget(self, action: #selector(btnTap_Like), for: .touchUpInside)
            cell.btn_cart.tag = indexPath.row
            cell.btn_cart.addTarget(self, action: #selector(btnTap_Cart), for: .touchUpInside)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    // MARK: - sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.Collectionview_SearchList {
            return CGSize(width: (UIScreen.main.bounds.width - 54) / 2, height: 290)
        }
        else {
            return CGSize.zero
        }
    }
    // MARK: - didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.Collectionview_SearchList {
            let data = self.SearchproductsArray[indexPath.item]
            let vc = self.storyboard?.instantiateViewController(identifier: "ItemDetailsVC") as! ItemDetailsVC
            vc.item_id = data["id"]!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // MARK: - willDisplay
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,forItemAt indexPath: IndexPath) {
        if collectionView == self.Collectionview_SearchList {
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" {
                if self.isfilterselected == "1" {
                    if indexPath.item == self.SearchproductsArray.count - 1 {
                        if self.pageIndex != self.lastIndex {
                            self.pageIndex = self.pageIndex + 1
                            if self.SearchproductsArray.count != 0 {
                                let urlString = API_URL + "search-guest?page=\(self.pageIndex)"
                                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                                let params: NSDictionary = ["type":"product_filter","tag":self.tag,"min_price":self.min_price,"max_price":self.max_price,"rating":self.rating,"name":self.txt_search.text!,"theme_id":APP_THEME]
                                self.Webservice_Searchproduct(url: urlString, params: params, header: headers)
                            }
                        }
                    }
                }
                else {
                    if indexPath.item == self.SearchproductsArray.count - 1 {
                        if self.pageIndex != self.lastIndex {
                            self.pageIndex = self.pageIndex + 1
                            if self.SearchproductsArray.count != 0 {
                                let urlString = API_URL + "search-guest?page=\(self.pageIndex)"
                                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                                let params: NSDictionary = ["type":"product_search","name":self.txt_search.text!,"theme_id":APP_THEME]
                                self.Webservice_Searchproduct(url: urlString, params: params, header: headers)
                            }
                        }
                    }
                }
            }
            else {
                if self.isfilterselected == "1" {
                    if indexPath.item == self.SearchproductsArray.count - 1 {
                        if self.pageIndex != self.lastIndex {
                            self.pageIndex = self.pageIndex + 1
                            if self.SearchproductsArray.count != 0 {
                                let urlString = API_URL + "search?page=\(self.pageIndex)"
                                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                                let params: NSDictionary = ["type":"product_filter","tag":self.tag,"min_price":self.min_price,"max_price":self.max_price,"rating":self.rating,"name":self.txt_search.text!,"theme_id":APP_THEME]
                                self.Webservice_Searchproduct(url: urlString, params: params, header: headers)
                            }
                        }
                    }
                }
                else {
                    if indexPath.item == self.SearchproductsArray.count - 1 {
                        if self.pageIndex != self.lastIndex {
                            self.pageIndex = self.pageIndex + 1
                            if self.SearchproductsArray.count != 0 {
                                let urlString = API_URL + "search?page=\(self.pageIndex)"
                                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                                let params: NSDictionary = ["type":"product_search","name":self.txt_search.text!,"theme_id":APP_THEME]
                                self.Webservice_Searchproduct(url: urlString, params: params, header: headers)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func btnTap_Like(sender:UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            keyWindow?.rootViewController = nav
        }
        else {
            let data = SearchproductsArray[sender.tag]
            if data["in_whishlist"]! == "false" {
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["id"]!,"wishlist_type":"add","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers, wishlisttype: "add", sender: sender.tag)
            }
            else if data["in_whishlist"]! == "true" {
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["id"]!,"wishlist_type":"remove","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers, wishlisttype: "remove",sender: sender.tag)
            }
        }
    }
    
    @objc func btnTap_Cart(sender:UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" {
            let data = SearchproductsArray[sender.tag]
            if UserDefaults.standard.value(forKey: UD_GuestObj) != nil {
                var Guest_Array = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestObj) as! [[String:String]]
                var iscart = false
                var cartindex = Int()
                for i in 0..<Guest_Array.count {
                    if Guest_Array[i]["product_id"]! == data["id"]! && Guest_Array[i]["variant_id"]! == data["default_variant_id"]! {
                        iscart = true
                        cartindex = i
                    }
                }
                if iscart == false {
                    let cartobj = ["product_id": data["id"]!,
                                   "image": data["cover_image_path"]!,
                                   "name": data["name"]!,
                                   "orignal_price": data["orignal_price"]!,
                                   "discount_price": data["discount_price"]!,
                                   "final_price": data["final_price"]!,
                                   "qty": "1",
                                   "variant_id": data["default_variant_id"]!,
                                   "variant_name": data["variant_name"]!]
                    Guest_Array.append(cartobj)
                    UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: Guest_Array, key: UD_GuestObj)
                    UserDefaultManager.setStringToUserDefaults(value: "\(Guest_Array.count)", key: UD_CartCount)
                    
                    let alert = UIAlertController(title: nil, message: "\(data["name"]!) add successfully", preferredStyle: .alert)
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
                else {
                    let alertVC = UIAlertController(title: Bundle.main.displayName!, message: ALREADYCART_CONFIRM_MESSAGE, preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                        
                        var data = Guest_Array[cartindex]
                        data["qty"] = "\(Int(data["qty"]!)! + 1)"
                        Guest_Array.remove(at: cartindex)
                        Guest_Array.insert(data, at: cartindex)
                        
                        UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: Guest_Array, key: UD_GuestObj)
                        UserDefaultManager.setStringToUserDefaults(value: "\(Guest_Array.count)", key: UD_CartCount)
                        
                    }
                    let noAction = UIAlertAction(title: "No", style: .destructive)
                    alertVC.addAction(noAction)
                    alertVC.addAction(yesAction)
                    self.present(alertVC,animated: true,completion: nil)
                }
            }
        }
        else {
            let data = SearchproductsArray[sender.tag]
            self.product_id = data["id"]!
            self.Selected_Variant_id = data["default_variant_id"]!
            let urlString = API_URL + "addtocart"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"variant_id":data["default_variant_id"]!,"qty":"1","product_id":data["id"]!,"theme_id":APP_THEME]
            self.Webservice_Cart(url: urlString, params: params, header: headers)
        }
    }
}

extension SearchVC : FilterDelegate {
    
    // MARK: - filterData
    func filterData(tag: String, min_price: String, max_price: String, rating: String, isfilter: String) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" {
            self.isfilterselected = isfilter
            self.tag = tag
            self.min_price = min_price
            self.max_price = max_price
            self.rating = rating
            self.pageIndex = 1
            self.lastIndex = 0
            let urlString = API_URL + "search-guest?page=\(self.pageIndex)"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["type":"product_filter","tag":tag,"min_price":min_price,"max_price":max_price,"rating":rating,"name":self.txt_search.text!,"theme_id":APP_THEME]
            self.Webservice_Searchproduct(url: urlString, params: params, header: headers)
        }
        else {
            self.isfilterselected = isfilter
            self.tag = tag
            self.min_price = min_price
            self.max_price = max_price
            self.rating = rating
            self.pageIndex = 1
            self.lastIndex = 0
            let urlString = API_URL + "search?page=\(self.pageIndex)"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["type":"product_filter","tag":tag,"min_price":min_price,"max_price":max_price,"rating":rating,"name":self.txt_search.text!,"theme_id":APP_THEME]
            self.Webservice_Searchproduct(url: urlString, params: params, header: headers)
        }
    }
}

extension SearchVC {
    // MARK: - searchproduct api calling
    func Webservice_Searchproduct(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                if self.pageIndex == 1 {
                    self.lastIndex = Int(jsondata["last_page"]!.stringValue)!
                    self.SearchproductsArray.removeAll()
                }
                let Searchdprodcutdata = jsondata["data"]!.arrayValue
                for data in Searchdprodcutdata
                {
                    let productObj = ["id":data["id"].stringValue,"name":data["name"].stringValue,"tag_api":data["tag_api"].stringValue,"cover_image_path":data["cover_image_path"].stringValue,"final_price":data["final_price"].stringValue,"in_whishlist":data["in_whishlist"].stringValue,"default_variant_id":data["default_variant_id"].stringValue,"orignal_price":data["original_price"].stringValue,"discount_price":data["discount_price"].stringValue,"variant_name":data["default_variant_name"].stringValue,"original_price":data["original_price"].stringValue,"discount_type":data["discount_type"].stringValue,"average_rating":data["average_rating"].stringValue,"average_ratings":data["average_rating"].stringValue]
                    self.SearchproductsArray.append(productObj)
                }
                self.lbl_searchresult.isHidden = false
                self.lbl_searchresult.text = "\(jsondata["total"]!.stringValue) results found:"
                self.Collectionview_SearchList.dataSource = self
                self.Collectionview_SearchList.delegate = self
                self.Collectionview_SearchList.reloadData()
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
    
    // MARK: - wishlist api calling
    func Webservice_wishlist(url:String, params:NSDictionary,header:NSDictionary,wishlisttype:String,sender:Int) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                if wishlisttype == "add"
                {
                    var data = self.SearchproductsArray[sender]
                    data["in_whishlist"]! = "true"
                    self.SearchproductsArray.remove(at: sender)
                    self.SearchproductsArray.insert(data, at: sender)
                    self.Collectionview_SearchList.reloadData()
                }
                else{
                    var data = self.SearchproductsArray[sender]
                    data["in_whishlist"]! = "false"
                    self.SearchproductsArray.remove(at: sender)
                    self.SearchproductsArray.insert(data, at: sender)
                    self.Collectionview_SearchList.reloadData()
                }
            }
            else if status == "9" {
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_TokenType)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    // MARK: - cart api calling
    func Webservice_Cart(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
                UserDefaultManager.setStringToUserDefaults(value: jsonResponse!["data"]["count"].stringValue, key: UD_CartCount)
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
            else if status == "9" {
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_TokenType)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else if status == "0" {
                let alertVC = UIAlertController(title: Bundle.main.displayName!, message: ALREADYCART_CONFIRM_MESSAGE, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    
                    let urlString = API_URL + "cart-qty"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":self.product_id,"variant_id":self.Selected_Variant_id,"quantity_type":"increase","theme_id":APP_THEME]
                    self.Webservice_CartQty(url: urlString, params: params, header: headers)
                    
                }
                let noAction = UIAlertAction(title: "No", style: .destructive)
                alertVC.addAction(noAction)
                alertVC.addAction(yesAction)
                self.present(alertVC,animated: true,completion: nil)
            }
            else {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    // MARK: - cartQty api calling
    func Webservice_CartQty(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
                UserDefaultManager.setStringToUserDefaults(value: jsonResponse!["count"].stringValue, key: UD_CartCount)
            }
            else if status == "9" {
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_TokenType)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
}
