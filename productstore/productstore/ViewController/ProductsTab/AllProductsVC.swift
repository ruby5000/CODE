
import UIKit
import SwiftyJSON

class AllProductsVC: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var Collectionview_ProductsList: UICollectionView!
    @IBOutlet weak var Height_ProductsListCollectionview: NSLayoutConstraint!
    
    @IBOutlet weak var Collectionview_ProductsListing: UICollectionView!
    @IBOutlet weak var Height_ProductsListingCollectionview: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_foundproducts: UILabel!
    @IBOutlet weak var Scroll_View: UIScrollView!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var lbl_bannerText: UILabel!
    @IBOutlet weak var img_Banner: UIImageView!
    @IBOutlet weak var view_Empty: UIView!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var lbl_strcategoires: UILabel!
    @IBOutlet weak var Height_ProductList: NSLayoutConstraint!
    
    var CategoriesArray = [JSON]()
    var selectedindex = 0
    var pageIndex = 1
    var lastIndex = 0
    var SelectedCategoryid = String()
    
    var FeaturedproductsArray = [[String:String]]()
    var Featuredproducts_Guest_Array = [JSON]()
    var maincategory_id = String()
    var ishome = String()
    var product_id = String()
    var Selected_Variant_id = String()
    var subcategory_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Scroll_View.delegate = self
        let urlString = API_URL + "product_banner"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["theme_id":APP_THEME]
        self.Webservice_ProductBanner(url: urlString, params: params, header: headers)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view_Empty.isHidden = false
        cornerRadius(viewName: self.lbl_count, radius: self.lbl_count.frame.height / 2)
        self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
        
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            if self.ishome == "yes"
            {
                self.Height_ProductList.constant = 20
                self.btn_back.isHidden = false
                self.tabBarController?.tabBar.isHidden = true
                self.lbl_strcategoires.isHidden = true
                
                self.Height_ProductsListingCollectionview.constant = 0
                self.pageIndex = 1
                self.lastIndex = 0
                let urlString = API_URL + "categorys-product-guest?page=\(self.pageIndex)"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["maincategory_id":self.maincategory_id,"theme_id":APP_THEME]
                self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                
            }
            else{
                self.Height_ProductList.constant = 365
                self.lbl_strcategoires.isHidden = false
                self.btn_back.isHidden = true
                self.tabBarController?.tabBar.isHidden = false
                let urlString = API_URL + "category-list"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["theme_id":APP_THEME]
                self.Webservice_category(url: urlString, params: params, header: headers)
            }
        }
        else{
            if self.ishome == "yes"
            {
                self.Height_ProductList.constant = 20
                self.lbl_strcategoires.isHidden = true
                self.btn_back.isHidden = false
                self.tabBarController?.tabBar.isHidden = true
                self.Height_ProductsListingCollectionview.constant = 0
                self.pageIndex = 1
                self.lastIndex = 0
                let urlString = API_URL + "categorys-product?page=\(self.pageIndex)"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["maincategory_id":self.maincategory_id,"theme_id":APP_THEME]
                self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
            }
            else{
                self.Height_ProductList.constant = 365
                self.lbl_strcategoires.isHidden = false
                self.btn_back.isHidden = true
                self.tabBarController?.tabBar.isHidden = false
                let urlString = API_URL + "category-list"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["theme_id":APP_THEME]
                self.Webservice_category(url: urlString, params: params, header: headers)
            }
        }
    }
}
//MARK: Button Actions
extension AllProductsVC
{
    @IBAction func btnTap_cart(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Tapback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: CollectionView Deleget methods
extension AllProductsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.Collectionview_ProductsListing
        {
            return self.CategoriesArray.count
        }
        else if collectionView == self.Collectionview_ProductsList
        {
            return self.FeaturedproductsArray.count
        }
        else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.Collectionview_ProductsListing
        {
            let cell = self.Collectionview_ProductsListing.dequeueReusableCell(withReuseIdentifier: "featuredListCell", for: indexPath) as! featuredListCell
            
            let data = CategoriesArray[indexPath.item]
            cell.lbl_title.text = data["name"].stringValue
            cell.img_cat.sd_setImage(with: URL(string: IMG_URL + data["image_path"].stringValue), placeholderImage: UIImage(named: ""))
            cornerRadius(viewName: cell.img_cat, radius: 8.0)
            if indexPath.item == self.selectedindex {
                setBorder(viewName: cell.cell_view, borderwidth: 1, borderColor: UIColor.init(named: "Second_Color")!.cgColor, cornerRadius: 10)
            } else {
                setBorder(viewName: cell.cell_view, borderwidth: 1, borderColor: UIColor.gray.cgColor, cornerRadius: 10)
            }
            
            return cell
            
        }
        
        else if collectionView == self.Collectionview_ProductsList
        {
            let cell = self.Collectionview_ProductsList.dequeueReusableCell(withReuseIdentifier: "featuredItemListCell", for: indexPath) as! featuredItemListCell
            let data = FeaturedproductsArray[indexPath.item]
            cell.lbl_itemname.text = data["name"]!
            let ItemPrice = formatter.string(for: data["final_price"]!.toDouble)
            let ItemoriginalPrice = formatter.string(for: data["original_price"]!.toDouble)
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(ItemoriginalPrice!) \(UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name))")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
           
            if data["discount_type"]! == "percentage"
            {
                cell.lbl_itemdiscountPrice.text = "\(data["discount_price"]!)%"
            }
            else{
                cell.lbl_itemdiscountPrice.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(data["discount_price"]!)"
            }
            
            cell.lbl_itemPrice.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
            let original3 = IMG_URL + data["cover_image_path"]!
            if let encoded = original3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let url = URL(string: encoded)
            {
                cell.img_item.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            }
            
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                cell.btn_favrites.isHidden = true
                cell.view_likeBtnBg.isHidden = true
            }
            else{
                cell.btn_favrites.isHidden = false
                cell.view_likeBtnBg.isHidden = false
            }
            
            if data["in_whishlist"]! == "false"
            {
                cell.btn_favrites.setImage(UIImage.init(named: "ic_hart"), for: .normal)
            }
            else if data["in_whishlist"]! == "true"
            {
                cell.btn_favrites.setImage(UIImage.init(named: "ic_hartfill"), for: .normal)
            }
            
            cell.lbl_rating.text = "\(data["average_rating"]!).0 / 5.0"
            cell.CosmosViews.rating = Double(data["average_ratings"]!)!
            
            cell.btn_favrites.tag = indexPath.row
            cell.btn_favrites.addTarget(self, action: #selector(btnTap_Like), for: .touchUpInside)
            cell.btn_cart.tag = indexPath.row
            cell.btn_cart.addTarget(self, action: #selector(btnTap_Carts), for: .touchUpInside)
            return cell
        }
        else
        {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.Collectionview_ProductsListing
        {
            return CGSize(width: (UIScreen.main.bounds.width - 54), height: 250)
        }
        else if collectionView == self.Collectionview_ProductsList
        {
            return CGSize(width: (UIScreen.main.bounds.width - 54) / 2, height: 336)
        }
        else
        {
            return CGSize.zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.Collectionview_ProductsList
        {
            let data = self.FeaturedproductsArray[indexPath.item]
            let vc = self.storyboard?.instantiateViewController(identifier: "ItemDetailsVC") as! ItemDetailsVC
            vc.item_id = data["id"]!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                if self.ishome == "yes"
                {
                    let data = CategoriesArray[indexPath.item]
                    self.pageIndex = 1
                    self.lastIndex = 0
                    let urlString = API_URL + "categorys-product-guest?page=\(self.pageIndex)"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    self.SelectedCategoryid = data["maincategory_id"].stringValue
                    let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                    self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    self.selectedindex = indexPath.item
                    self.Collectionview_ProductsListing.reloadData()
                }
                else{
                    let data = CategoriesArray[indexPath.item]
                    self.pageIndex = 1
                    self.lastIndex = 0
                    let urlString = API_URL + "categorys-product-guest?page=\(self.pageIndex)"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    self.SelectedCategoryid = data["maincategory_id"].stringValue
                    let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                    self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    self.selectedindex = indexPath.item
                    self.Collectionview_ProductsListing.reloadData()
                }
            }
            else{
                if self.ishome == "yes"
                {
                    let data = CategoriesArray[indexPath.item]
                    self.pageIndex = 1
                    self.lastIndex = 0
                    let urlString = API_URL + "categorys-product?page=\(self.pageIndex)"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    self.SelectedCategoryid = data["maincategory_id"].stringValue
                    let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                    self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    self.selectedindex = indexPath.item
                    self.Collectionview_ProductsListing.reloadData()
                }
                else{
                    let data = CategoriesArray[indexPath.item]
                    self.pageIndex = 1
                    self.lastIndex = 0
                    let urlString = API_URL + "categorys-product?page=\(self.pageIndex)"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    self.SelectedCategoryid = data["maincategory_id"].stringValue
                    let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                    self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    
                    self.selectedindex = indexPath.item
                    self.Collectionview_ProductsListing.reloadData()
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (Int(self.Scroll_View.contentOffset.y) >=  Int(self.Scroll_View.contentSize.height - self.Scroll_View.frame.size.height)) {
            if self.pageIndex != self.lastIndex {
                self.pageIndex = self.pageIndex + 1
                if self.FeaturedproductsArray.count != 0 {
                    if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
                    {
                        let urlString = API_URL + "categorys-product-guest?page=\(self.pageIndex)"
                        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                        let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                        self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    }
                    else{
                        let urlString = API_URL + "categorys-product?page=\(self.pageIndex)"
                        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                        let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                        self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    }
                    
                }
            }
        }
    }
    
    @objc func btnTap_Like(sender:UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            keyWindow?.rootViewController = nav
        }
        else{
            let data = FeaturedproductsArray[sender.tag]
            if data["in_whishlist"]! == "false"
            {
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["id"]!,"wishlist_type":"add","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers, wishlisttype: "add", sender: sender.tag)
            }
            else if data["in_whishlist"]! == "true"
            {
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["id"]!,"wishlist_type":"remove","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers, wishlisttype: "remove",sender: sender.tag)
            }
        }
    }
    
    @objc func btnTap_Carts(sender:UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let data = FeaturedproductsArray[sender.tag]
            if UserDefaults.standard.value(forKey: UD_GuestObj) != nil
            {
                var Guest_Array = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestObj) as! [[String:String]]
                var iscart = false
                var cartindex = Int()
                for i in 0..<Guest_Array.count
                {
                    if Guest_Array[i]["product_id"]! == data["id"]! && Guest_Array[i]["variant_id"]! == data["default_variant_id"]!
                    {
                        iscart = true
                        cartindex = i
                    }
                }
                if iscart == false
                {
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
                    self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
                    let alert = UIAlertController(title: nil, message: "\(data["name"]!) add successfully", preferredStyle: .alert)
                    let ContinueAction = UIAlertAction(title: "Continue shopping", style: .default) { (action) in
                        self.dismiss(animated: true)
                    }
                    
                    let ProceedAction = UIAlertAction(title: "Proceed to check out", style: .default) { (action) in
                        let vc = self.storyboard?.instantiateViewController(identifier: "CartVC") as! CartVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(ContinueAction)
                    alert.addAction(ProceedAction)
                    // alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
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
        else
        {
            let data = FeaturedproductsArray[sender.tag]
            self.product_id = data["id"]!
            self.Selected_Variant_id = data["default_variant_id"]!
            let urlString = API_URL + "addtocart"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"variant_id":data["default_variant_id"]!,"qty":"1","product_id":data["id"]!,"theme_id":APP_THEME]
            self.Webservice_Cart(url: urlString, params: params, header: headers)
            
        }
    }
}
extension AllProductsVC
{
    func Webservice_category(url:String, params:NSDictionary, header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                
                if self.ishome == "yes"
                {
                    let jsondata = jsonResponse!["data"].dictionaryValue
                    self.CategoriesArray = jsondata["subcategory"]!.arrayValue
                }
                else{
                    let jsondata = jsonResponse!["data"].arrayValue
                    self.CategoriesArray = jsondata
                }
                
                self.selectedindex = 0
                self.Collectionview_ProductsListing.delegate = self
                self.Collectionview_ProductsListing.dataSource = self
                self.Collectionview_ProductsListing.reloadData()
                //self.Height_ProductsListingCollectionview.constant = 280
                
                if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
                {
                    if self.ishome == "yes"
                    {
                        let data = self.CategoriesArray[self.selectedindex]
                        self.pageIndex = 1
                        self.lastIndex = 0
                        let urlString = API_URL + "categorys-product-guest?page=\(self.pageIndex)"
                        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                        self.SelectedCategoryid = data["maincategory_id"].stringValue
                        let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                        self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    }
                    else{
                        let data = self.CategoriesArray[self.selectedindex]
                        self.pageIndex = 1
                        self.lastIndex = 0
                        let urlString = API_URL + "categorys-product-guest?page=\(self.pageIndex)"
                        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                        self.SelectedCategoryid = data["maincategory_id"].stringValue
                        let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                        self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    }
                }
                else{
                    if self.ishome == "yes"
                    {
                        let data = self.CategoriesArray[self.selectedindex]
                        self.pageIndex = 1
                        self.lastIndex = 0
                        let urlString = API_URL + "categorys-product?page=\(self.pageIndex)"
                        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                        self.SelectedCategoryid = data["maincategory_id"].stringValue
                        let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                        self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                        
                    }
                    else
                    {
                        let data = self.CategoriesArray[self.selectedindex]
                        self.pageIndex = 1
                        self.lastIndex = 0
                        let urlString = API_URL + "categorys-product?page=\(self.pageIndex)"
                        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                        self.SelectedCategoryid = data["maincategory_id"].stringValue
                        let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                        self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    }
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
    
    func Webservice_Categorysproduct(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                if self.pageIndex == 1 {
                    self.lastIndex = Int(jsondata["last_page"]!.stringValue)!
                    self.FeaturedproductsArray.removeAll()
                }
                let Featuredprodcutdata = jsondata["data"]!.arrayValue
                self.Featuredproducts_Guest_Array = Featuredprodcutdata
                
                for data in Featuredprodcutdata
                {
                    let productObj = ["id":data["id"].stringValue,"name":data["name"].stringValue,"tag_api":data["tag_api"].stringValue,"cover_image_path":data["cover_image_path"].stringValue,"final_price":data["final_price"].stringValue,"in_whishlist":data["in_whishlist"].stringValue,"default_variant_id":data["default_variant_id"].stringValue,"orignal_price":data["original_price"].stringValue,"discount_price":data["discount_price"].stringValue,"variant_name":data["default_variant_name"].stringValue,"original_price":data["original_price"].stringValue,"discount_type":data["discount_type"].stringValue,"average_rating":data["average_rating"].stringValue,"average_ratings":data["average_rating"].stringValue]
                    self.FeaturedproductsArray.append(productObj)
                }
                
                self.lbl_foundproducts.text = "Found \(jsondata["total"]!.stringValue) products"
                self.Collectionview_ProductsList.delegate = self
                self.Collectionview_ProductsList.dataSource = self
                self.Collectionview_ProductsList.reloadData()
                
                self.Height_ProductsListCollectionview.constant = CGFloat(self.FeaturedproductsArray.count) * 280
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.Height_ProductsListCollectionview.constant = self.Collectionview_ProductsList.contentSize.height
                }
                
                self.view_Empty.isHidden = true
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
                self.view_Empty.isHidden = false
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    func Webservice_wishlist(url:String, params:NSDictionary,header:NSDictionary,wishlisttype:String,sender:Int) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                if wishlisttype == "add"
                {
                    var data = self.FeaturedproductsArray[sender]
                    data["in_whishlist"]! = "true"
                    self.FeaturedproductsArray.remove(at: sender)
                    self.FeaturedproductsArray.insert(data, at: sender)
                    self.Collectionview_ProductsList.reloadData()
                }
                else{
                    var data = self.FeaturedproductsArray[sender]
                    data["in_whishlist"]! = "false"
                    self.FeaturedproductsArray.remove(at: sender)
                    self.FeaturedproductsArray.insert(data, at: sender)
                    self.Collectionview_ProductsList.reloadData()
                }
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
    func Webservice_ProductBanner(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let data = jsonResponse!["data"].dictionaryValue
                let themjson = data["them_json"]!["products-header-banner"].dictionaryValue
                self.lbl_bannerText.text! = themjson["products-header-banner-title-text"]!.stringValue
                self.img_Banner.sd_setImage(with: URL(string: IMG_URL + themjson["products-header-banner"]!.stringValue), placeholderImage: UIImage(named: ""))
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
