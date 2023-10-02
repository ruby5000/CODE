import UIKit
import SwiftyJSON
import SDWebImage
import Cosmos
import ImageSlideshow

class featuredListCell : UICollectionViewCell
{
    @IBOutlet weak var img_cat: UIImageView!
    @IBOutlet weak var cell_view: UIView!
    @IBOutlet weak var lbl_title: UILabel!
}

class featuredItemListCell : UICollectionViewCell
{
    @IBOutlet weak var btn_favrites: UIButton!
    @IBOutlet weak var view_likeBtnBg: UIView!
    @IBOutlet weak var lbl_itemdiscountPrice: UILabel!
    @IBOutlet weak var lbl_itemPrice: UILabel!
    @IBOutlet weak var lbl_itemname: UILabel!
    @IBOutlet weak var img_item: UIImageView!
    @IBOutlet weak var btn_cart: UIButton!
    @IBOutlet weak var lbl_currency: UILabel!
    @IBOutlet weak var lbl_tag: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var CosmosViews: CosmosView!
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var Collectionview_Testimonial: UICollectionView!
    @IBOutlet weak var HeightView_Testimonials: NSLayoutConstraint!
    @IBOutlet weak var View_Testimonials: UIView!
    
    // home-header
    @IBOutlet weak var home_header_title_text: UILabel!
    @IBOutlet weak var home_header_sub_text: UILabel!
    @IBOutlet weak var homepage_header_btn: UIButton!
    
    //homepage-category
    @IBOutlet weak var homepage_category_title_text: UILabel!
    
    //homepage-products
    @IBOutlet weak var homepage_products_title_text: UILabel!
    @IBOutlet weak var homepage_products_sub_title_text: UILabel!
    @IBOutlet weak var homepage_product_discount_text: UILabel!
    
    // homepage-banner
    @IBOutlet weak var homepage_banner_bg_img: UIImageView!
    @IBOutlet weak var homepage_banner_title_text: UILabel!
    @IBOutlet weak var homepage_banner_sub_text: UILabel!
    @IBOutlet weak var homepage_banner_heading_text: UILabel!
    
    // homepage_custom_banner
    @IBOutlet weak var homepage_custom_banner_bg_img: UIImageView!
    @IBOutlet weak var homepage_custom_banner_title_text: UILabel!
    @IBOutlet weak var homepage_custom_banner_sub_text: UILabel!
    @IBOutlet weak var homepage_custom_banner_heading_text: UILabel!
    
    // homepage-testimonial
    @IBOutlet weak var homepage_testimonial_title_text: UILabel!
    @IBOutlet weak var homepage_testimonial_discount_text: UILabel!
    
    @IBOutlet weak var HeightCollectionview_BestSeleers: NSLayoutConstraint!
    @IBOutlet weak var HeightCollectionview_TrendingProducts: NSLayoutConstraint!
    @IBOutlet weak var heightTableview_Categories: NSLayoutConstraint!
    
    @IBOutlet weak var Collectionview_Bestsellers: UICollectionView!
    @IBOutlet weak var Collectionview_TrendingProducts: UICollectionView!
    @IBOutlet weak var tableview_categories: UITableView!
    
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var view_Empty: UIView!
    @IBOutlet weak var img_product: UIImageView!
    @IBOutlet weak var image_Slider: ImageSlideshow!
    
    var Categories_Array = [JSON]()
    var Testimonials_Array = [JSON]()
    var Home_Categories_Array = [[String:String]]()
    var pageIndex = 1
    var lastIndex = 0
    var pageIndex_best = 1
    var lastIndex_best = 0
    var productImages = [SDWebImageSource]()
    var pageIndex_maincategory = 1
    var lastIndex_maincategory = 0
    var SelectedCategoryid = String()
    var Featured_Products_Array = [[String:String]]()
    var Bestseller_Products_Array = [[String:String]]()
    var Trending_Products_Array = [[String:String]]()
    var selectedindex = 0
    var selectedindex_Trending = 0
    
    var product_id = String()
    var Selected_Variant_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.View_Testimonials.isHidden = true
        self.HeightView_Testimonials.constant = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view_Empty.isHidden = false
        cornerRadius(viewName: self.lbl_count, radius: self.lbl_count.frame.height / 2)
        self.tabBarController?.tabBar.isHidden = false
        if UserDefaults.standard.value(forKey: UD_GuestObj) != nil
        {
            let Guest_Array = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestObj) as! [[String:String]]
            UserDefaultManager.setStringToUserDefaults(value: "\(Guest_Array.count)", key: UD_CartCount)
            self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
        }
        
        let urlString = BASE_URL
        let headers:NSDictionary = ["Content-type": "application/json"]
        let params: NSDictionary = ["theme_id":APP_THEME]
        self.Webservice_baseURL(url: urlString, params: params, header: headers)
    }
    
    func imageSliderData() {
        self.image_Slider.slideshowInterval = 3.0
        self.image_Slider.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 10.0))
        self.image_Slider.contentScaleMode = UIView.ContentMode.scaleToFill
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.image_Slider.pageIndicator = pageControl
        self.image_Slider.setImageInputs(self.productImages)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapImage))
        self.image_Slider.addGestureRecognizer(recognizer)
    }
    @objc func didTapImage() {
        self.image_Slider.presentFullScreenController(from: self)
    }
    
    @IBAction func btnTap_GotoCategories(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    @IBAction func btnTap_ShowProducts(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
}
extension HomeVC
{
    
    @IBAction func btnTap_Menu(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnTap_Search(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        // vc.example = self.homepage_search_product_ie.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTap_Cart(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Home_Categories_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 370
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview_categories.dequeueReusableCell(withIdentifier: "AllCategoriesCell") as! AllCategoriesCell
        let data = self.Home_Categories_Array[indexPath.item]
        cornerRadius(viewName: cell.img_catimage, radius: 8.0)
        cell.lbl_categories.text = data["name"]!

        let original3 = IMG_URL + data["image_path"]!
        if let encoded = original3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encoded)
        {
            cell.img_catimage.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
        
        cell.btn_Find.tag = indexPath.row
        cell.btn_Find.addTarget(self, action: #selector(btnTap_Find), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let data = self.Home_Categories_Array[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = data["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func btnTap_Find(sender:UIButton)
    {
        let data = self.Home_Categories_Array[sender.tag]
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = data["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - CollectionView Deleget methods
extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.Collectionview_Bestsellers
        {
            return self.Bestseller_Products_Array.count
        }
        if collectionView == self.Collectionview_TrendingProducts
        {
            return self.Trending_Products_Array.count
        }
        if collectionView == self.Collectionview_Testimonial
        {
            return self.Testimonials_Array.count
        }
        else
        {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.Collectionview_Bestsellers
        {
            let cell = self.Collectionview_Bestsellers.dequeueReusableCell(withReuseIdentifier: "featuredItemListCell", for: indexPath) as! featuredItemListCell
            let data = Bestseller_Products_Array[indexPath.item]
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
            }
            else{
                cell.btn_favrites.isHidden = false
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
            cell.btn_favrites.addTarget(self, action: #selector(btnTapBestProduct_Like), for: .touchUpInside)
            cell.btn_cart.tag = indexPath.row
            cell.btn_cart.addTarget(self, action: #selector(btnTapBestProduct_Carts), for: .touchUpInside)
            return cell
        }
        if collectionView == self.Collectionview_Testimonial
        {
            let cell = self.Collectionview_Testimonial.dequeueReusableCell(withReuseIdentifier: "RattingsListCell", for: indexPath) as! RattingsListCell
            let data = self.Testimonials_Array[indexPath.item]
            cell.lbl_title.text = data["title"].stringValue
            cell.lbl_subtitle.text = data["description"].stringValue
            cell.lbl_Username.text = data["user_name"].stringValue
            cell.lbl_rating.text = "\(data["rating_no"].stringValue).0 / 5.0"
            
            let original3 = IMG_URL + data["product_image_path"].stringValue
            if let encoded = original3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let url = URL(string: encoded)
            {
                cell.img_product.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            }
            cell.CosmosViews.rating = data["rating_no"].doubleValue
            return cell
        }
        else if collectionView == self.Collectionview_TrendingProducts
        {
            let cell = self.Collectionview_TrendingProducts.dequeueReusableCell(withReuseIdentifier: "featuredItemListCell", for: indexPath) as! featuredItemListCell
            let data = Trending_Products_Array[indexPath.item]
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
            }
            else{
                cell.btn_favrites.isHidden = false
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
            cell.btn_favrites.addTarget(self, action: #selector(btnTapTrendingProduct_Like), for: .touchUpInside)
            cell.btn_cart.tag = indexPath.row
            cell.btn_cart.addTarget(self, action: #selector(btnTapTrendingProduct_Carts), for: .touchUpInside)
            return cell
        }
        else
        {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.Collectionview_Bestsellers
        {
            return CGSize(width: (UIScreen.main.bounds.width - 54), height: 612)
        }
        if collectionView == self.Collectionview_TrendingProducts
        {
            return CGSize(width: (UIScreen.main.bounds.width - 54), height: 612)
        }
        if collectionView == self.Collectionview_Testimonial
        {
            return CGSize(width: collectionView.bounds.size.width - 10, height: 260)
        }
        else
        {
            return CGSize.zero
        }
    }
    // MARK: - CollectionView didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.Collectionview_Bestsellers  {
            let data = self.Bestseller_Products_Array[indexPath.item]
            let vc = self.storyboard?.instantiateViewController(identifier: "ItemDetailsVC") as! ItemDetailsVC
            vc.item_id = data["id"]!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView == self.Collectionview_TrendingProducts {
            let data = self.Trending_Products_Array[indexPath.item]
            let vc = self.storyboard?.instantiateViewController(identifier: "ItemDetailsVC") as! ItemDetailsVC
            vc.item_id = data["id"]!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,forItemAt indexPath: IndexPath)
    {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            if collectionView == self.Collectionview_TrendingProducts
            {
                if indexPath.item == self.Trending_Products_Array.count - 1 {
                    if self.pageIndex != self.lastIndex {
                        self.pageIndex = self.pageIndex + 1
                        if self.Trending_Products_Array.count != 0 {
                            let urlString = API_URL + "tranding-category-product-guest?page=\(self.pageIndex)"
                            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                            let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                            self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                        }
                    }
                }
            }
            else if collectionView == self.Collectionview_Bestsellers
            {
                if indexPath.item == self.Bestseller_Products_Array.count - 1 {
                    if self.pageIndex_best != self.lastIndex_best {
                        self.pageIndex_best = self.pageIndex_best + 1
                        if self.Bestseller_Products_Array.count != 0 {
                            
                            let urlString4 = API_URL + "bestseller-guest?page=\(self.pageIndex_best)"
                            let headers4:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                            let params4: NSDictionary = ["theme_id":APP_THEME]
                            self.Webservice_Bestsellerprodcuts(url: urlString4, params: params4, header: headers4)
                        }
                    }
                }
            }
        }
        else {
            if collectionView == self.Collectionview_TrendingProducts
            {
                if indexPath.item == self.Trending_Products_Array.count - 1 {
                    if self.pageIndex != self.lastIndex {
                        self.pageIndex = self.pageIndex + 1
                        if self.Trending_Products_Array.count != 0 {
                            let urlString = API_URL + "tranding-category-product?page=\(self.pageIndex)"
                            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                            let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                            self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                        }
                    }
                }
            }
            else if collectionView == self.Collectionview_Bestsellers
            {
                if indexPath.item == self.Bestseller_Products_Array.count - 1 {
                    if self.pageIndex_best != self.lastIndex_best {
                        self.pageIndex_best = self.pageIndex_best + 1
                        if self.Bestseller_Products_Array.count != 0 {
                            let urlString4 = API_URL + "bestseller?page=\(self.pageIndex_best)"
                            let headers4:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                            let params4: NSDictionary = ["theme_id":APP_THEME]
                            self.Webservice_Bestsellerprodcuts(url: urlString4, params: params4, header: headers4)
                        }
                    }
                }
            }
        }
    }
    
    @objc func btnTap_ShowMore(sender:UIButton)
    {
        let data = self.Home_Categories_Array[sender.tag]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllProductsVC") as! AllProductsVC
        vc.ishome = "yes"
        vc.maincategory_id = data["category_id"]!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnTapBestProduct_Like(sender:UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            keyWindow?.rootViewController = nav
        }
        else{
            let data = self.Bestseller_Products_Array[sender.tag]
            if data["in_whishlist"]! == "false"
            {
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["id"]!,"wishlist_type":"add","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers, wishlisttype: "add", sender: sender.tag, isselect: "Best")
            }
            else if data["in_whishlist"]! == "true"
            {
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["id"]!,"wishlist_type":"remove","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers, wishlisttype: "remove",sender: sender.tag, isselect: "Best")
            }
        }
    }
    @objc func btnTapBestProduct_Carts(sender:UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let data = Bestseller_Products_Array[sender.tag]
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
            let data = Bestseller_Products_Array[sender.tag]
            self.product_id = data["id"]!
            self.Selected_Variant_id = data["default_variant_id"]!
            let urlString = API_URL + "addtocart"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"variant_id":data["default_variant_id"]!,"qty":"1","product_id":data["id"]!,"theme_id":APP_THEME]
            self.Webservice_Cart(url: urlString, params: params, header: headers)
            
        }
    }
    @objc func btnTapTrendingProduct_Like(sender:UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            keyWindow?.rootViewController = nav
        }
        else{
            let data = self.Trending_Products_Array[sender.tag]
            if data["in_whishlist"]! == "false"
            {
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["id"]!,"wishlist_type":"add","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers, wishlisttype: "add", sender: sender.tag, isselect: "Trending")
            }
            else if data["in_whishlist"]! == "true"
            {
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["id"]!,"wishlist_type":"remove","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers, wishlisttype: "remove",sender: sender.tag, isselect: "Trending")
            }
        }
    }
    @objc func btnTapTrendingProduct_Carts(sender:UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let data = Trending_Products_Array[sender.tag]
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
                    alert.addAction(ContinueAction)
                    alert.addAction(ProceedAction)
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
            let data = Trending_Products_Array[sender.tag]
            self.product_id = data["id"]!
            self.Selected_Variant_id = data["default_variant_id"]!
            let urlString = API_URL + "addtocart"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"variant_id":data["default_variant_id"]!,"qty":"1","product_id":data["id"]!,"theme_id":APP_THEME]
            self.Webservice_Cart(url: urlString, params: params, header: headers)
            
        }
    }
}
extension HomeVC : ProductListDelegate
{
    func getdata(subcategory_id: String, maincategory_id: String, categories_name: String) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = maincategory_id
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeVC {
    
    func Webservice_baseURL(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                IMG_URL = jsondata["image_url"]!.stringValue
                API_URL = "\(jsondata["base_url"]!.stringValue)/"
                PAYMENT_URL = "\(jsondata["payment_url"]!.stringValue)/"
                
                let urlString = API_URL + "landingpage"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["theme_id":APP_THEME]
                self.Webservice_landingpage(url: urlString, params: params, header: headers)
                
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
    
    // MARK: - landing page api calling
    func Webservice_landingpage(url:String, params:NSDictionary, header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters: params, httpMethod: "POST", progressView: true, uiView: self.view, networkAlert: true)
        {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
                let jsondata = jsonResponse!["data"]["them_json"].dictionaryValue
                
                // homepage-header
                let home_header = jsondata["homepage-header"]!.dictionaryValue
                self.home_header_title_text.text = home_header["homepage-header-title-text"]!.stringValue
                self.home_header_sub_text.text = home_header["homepage-header-sub-text"]!.stringValue
                self.homepage_header_btn.setTitle(home_header["homepage-header-btn-text"]!.stringValue, for: .normal)
                
                let productImages = home_header["homepage-header-img"]!.arrayValue
                for image in 0..<productImages.count {
                    let endpoint = productImages[image].stringValue
                    let imageSource = SDWebImageSource(url: URL(string: IMG_URL + endpoint)!, placeholder: UIImage(named: ""))
                    self.productImages.append(imageSource)
                }
                self.imageSliderData()
                
                // homepage-discount
                let homepage_discount = jsondata["homepage-discount"]!.dictionaryValue
                self.homepage_product_discount_text.text = homepage_discount["homepage-discount-title-text"]!.stringValue
                self.homepage_testimonial_discount_text.text = homepage_discount["homepage-discount-title-text"]!.stringValue
                
                //homepage-products
                let homepage_products = jsondata["homepage-products"]!.dictionaryValue
                self.homepage_products_title_text.text = homepage_products["homepage-products-title-text"]!.stringValue
                self.homepage_products_sub_title_text.text = homepage_products["homepage-products-sub-text"]!.stringValue
                
                //homepage-category
                let homepage_category = jsondata["homepage-category"]!.dictionaryValue
                self.homepage_category_title_text.text = homepage_category["homepage-category-title-text"]!.stringValue
                
                // homepage_custom_banner
                let homepage_custom_banner = jsondata["homepage-custom-banner"]!.dictionaryValue
                self.homepage_custom_banner_title_text.text = homepage_custom_banner["homepage-custom-banner-title-text"]!.stringValue
                self.homepage_custom_banner_sub_text.text = homepage_custom_banner["homepage-custom-banner-sub-text"]!.stringValue
                self.homepage_custom_banner_heading_text.text = homepage_custom_banner["homepage-custom-banner-heading-text"]!.stringValue
                self.homepage_custom_banner_bg_img.sd_setImage(with: URL(string: IMG_URL + homepage_custom_banner["homepage-custom-banner-img"]!.stringValue), placeholderImage: UIImage(named: ""))
                
                //homepage-testimonial
                let homepage_testimonial = jsondata["homepage-testimonial"]!.dictionaryValue
                self.homepage_testimonial_title_text.text = homepage_testimonial["homepage-testimonial-title-text"]!.stringValue
                
                //------------------------------API CALL ----------------------------------------//
                
                let urlString1 = API_URL + "currency"
                let headers1:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params1: NSDictionary = ["theme_id":APP_THEME]
                self.Webservice_currency(url: urlString1, params: params1, header: headers1)
                
                if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
                {
                    self.pageIndex = 1
                    self.lastIndex = 0
                    let urlString = API_URL + "categorys-product-guest?page=\(self.pageIndex)"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                    self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    
                    
                    self.pageIndex_best = 1
                    self.lastIndex_best = 0
                    let urlString4 = API_URL + "bestseller-guest?page=\(self.pageIndex_best)"
                    let headers4:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params4: NSDictionary = ["theme_id":APP_THEME]
                    self.Webservice_Bestsellerprodcuts(url: urlString4, params: params4, header: headers4)
                    
                }
                else{
                    self.pageIndex = 1
                    self.lastIndex = 0
                    let urlString = API_URL + "categorys-product?page=\(self.pageIndex)"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["maincategory_id":self.SelectedCategoryid,"theme_id":APP_THEME]
                    self.Webservice_Categorysproduct(url: urlString, params: params, header: headers)
                    
                    self.pageIndex_best = 1
                    self.lastIndex_best = 0
                    let urlString4 = API_URL + "bestseller?page=\(self.pageIndex_best)"
                    let headers4:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params4: NSDictionary = ["theme_id":APP_THEME]
                    self.Webservice_Bestsellerprodcuts(url: urlString4, params: params4, header: headers4)
                    
                }
                
                self.pageIndex_maincategory = 1
                self.lastIndex_maincategory = 0
                let urlString3 = API_URL + "home-categoty?page=\(self.pageIndex_maincategory)"
                let headers3:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params3: NSDictionary = ["theme_id":APP_THEME]
                self.Webservice_Homecategory(url: urlString3, params: params3, header: headers3)
                
                let urlString5 = API_URL + "random_review?page=\(self.pageIndex_best)"
                let headers5:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params5: NSDictionary = ["theme_id":APP_THEME]
                self.Webservice_RandomReview(url: urlString5, params: params5, header: headers5)
            }
        }
    }
    func Webservice_currency(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                UserDefaultManager.setStringToUserDefaults(value: jsondata["currency"]!.stringValue, key: UD_currency)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["currency_name"]!.stringValue, key: UD_currency_Name)
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
    
    // MARK: - categories api calling
    //    func Webservice_category(url:String, params:NSDictionary, header:NSDictionary) -> Void {
    //        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
    //            let status = jsonResponse!["status"].stringValue
    //            if status == "1" {
    //                let jsondata = jsonResponse!["data"].arrayValue
    //                self.Categories_Array = jsondata
    //                self.Collectionview_Bestsellers.delegate = self
    //                self.Collectionview_Bestsellers.dataSource = self
    //                self.Collectionview_Bestsellers.reloadData()
    //            }
    //            else if status == "9" {
    //                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
    //                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
    //                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_TokenType)
    //                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    //                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
    //                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
    //                nav.navigationBar.isHidden = true
    //                keyWindow?.rootViewController = nav
    //            }
    //            else {
    //                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
    //            }
    //        }
    //    }
    
    func Webservice_Categorysproduct(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                if self.pageIndex == 1 {
                    self.lastIndex = Int(jsondata["last_page"]!.stringValue)!
                    self.Trending_Products_Array.removeAll()
                }
                let Featuredprodcutdata = jsondata["data"]!.arrayValue
                for data in Featuredprodcutdata
                {
                    
                    let productObj = ["id":data["id"].stringValue,"name":data["name"].stringValue,"tag_api":data["tag_api"].stringValue,"cover_image_path":data["cover_image_path"].stringValue,"final_price":data["final_price"].stringValue,"in_whishlist":data["in_whishlist"].stringValue,"default_variant_id":data["default_variant_id"].stringValue,"orignal_price":data["original_price"].stringValue,"discount_price":data["discount_price"].stringValue,"variant_name":data["default_variant_name"].stringValue,"original_price":data["original_price"].stringValue,"discount_type":data["discount_type"].stringValue,"average_rating":data["average_rating"].stringValue,"average_ratings":data["average_rating"].stringValue]
                    
                    self.Trending_Products_Array.append(productObj)
                }
                
                self.Collectionview_TrendingProducts.delegate = self
                self.Collectionview_TrendingProducts.dataSource = self
                self.Collectionview_TrendingProducts.reloadData()
                //self.HeightCollectionview_BestsellersProducts.constant = 300
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
    func Webservice_Homecategory(url:String, params:NSDictionary, header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
                
                let jsondata = jsonResponse!["data"].dictionaryValue
                if self.pageIndex_maincategory == 1 {
                    self.lastIndex_maincategory = Int(jsondata["last_page"]!.stringValue)!
                    self.Home_Categories_Array.removeAll()
                }
                let Featuredprodcutdata = jsondata["data"]!.arrayValue
                for data in Featuredprodcutdata {
                    let productObj = ["id":data["id"].stringValue,"name":data["name"].stringValue,"image_path":data["image_path"].stringValue,"status":data["status"].stringValue,"category_id":data["category_id"].stringValue,"category_item":data["category_item"].stringValue,"icon_path":data["icon_path"].stringValue]
                    self.Home_Categories_Array.append(productObj)
                }
                
                self.tableview_categories.reloadData()
                self.tableview_categories.delegate = self
                self.tableview_categories.dataSource = self
                self.heightTableview_Categories.constant = CGFloat(self.Home_Categories_Array.count*370)
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
    func Webservice_Bestsellerprodcuts(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
                let jsondata = jsonResponse!["data"].dictionaryValue
                if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""  {
                    self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
                }
                else{
                    
                    UserDefaultManager.setStringToUserDefaults(value: jsonResponse!["count"].stringValue, key: UD_CartCount)
                    self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
                }
                if self.pageIndex_best == 1 {
                    self.lastIndex_best = Int(jsondata["last_page"]!.stringValue)!
                    self.Bestseller_Products_Array.removeAll()
                }
                let Featuredprodcutdata = jsondata["data"]!.arrayValue
                for data in Featuredprodcutdata  {
                    let productObj = ["id":data["id"].stringValue,
                                      "name":data["name"].stringValue,
                                      "tag_api":data["tag_api"].stringValue,
                                      "cover_image_path":data["cover_image_path"].stringValue,
                                      "final_price":data["final_price"].stringValue,
                                      "in_whishlist":data["in_whishlist"].stringValue,
                                      "default_variant_id":data["default_variant_id"].stringValue,
                                      "orignal_price":data["original_price"].stringValue,"discount_price":data["discount_price"].stringValue,"variant_name":data["default_variant_name"].stringValue,"original_price":data["original_price"].stringValue,"discount_type":data["discount_type"].stringValue,"average_rating":data["average_rating"].stringValue,"average_ratings":data["average_rating"].stringValue]
                    self.Bestseller_Products_Array.append(productObj)
                }
                
                self.Collectionview_Bestsellers.delegate = self
                self.Collectionview_Bestsellers.dataSource = self
                self.Collectionview_Bestsellers.reloadData()
                //self.HeightCollectionview_TopProductsList.constant = 300
                
                let urlString = API_URL + "extra-url"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["theme_id":APP_THEME]
                self.Webservice_Extraurl(url: urlString, params: params, header: headers)
                self.view_Empty.isHidden = true
                
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
    func Webservice_Extraurl(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                UserDefaultManager.setStringToUserDefaults(value: jsondata["contact_us"]!.stringValue, key: UD_ContactusURL)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["terms"]!.stringValue, key: UD_TermsURL)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["youtube"]!.stringValue, key: UD_YoutubeURL)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["messanger"]!.stringValue, key: UD_MessageURL)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["insta"]!.stringValue, key: UD_InstaURL)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["twitter"]!.stringValue, key: UD_TwitterURL)
                UserDefaultManager.setStringToUserDefaults(value: jsondata["return_policy"]!.stringValue, key: UD_ReturnPolicyURL)
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
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    func Webservice_wishlist(url:String, params:NSDictionary,header:NSDictionary,wishlisttype:String,sender:Int,isselect:String) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                if isselect == "Best"
                {
                    if wishlisttype == "add"
                    {
                        var data = self.Bestseller_Products_Array[sender]
                        data["in_whishlist"]! = "true"
                        self.Bestseller_Products_Array.remove(at: sender)
                        self.Bestseller_Products_Array.insert(data, at: sender)
                        self.Collectionview_Bestsellers.reloadData()
                    }
                    else
                    {
                        var data = self.Bestseller_Products_Array[sender]
                        data["in_whishlist"]! = "false"
                        self.Bestseller_Products_Array.remove(at: sender)
                        self.Bestseller_Products_Array.insert(data, at: sender)
                        self.Collectionview_Bestsellers.reloadData()
                    }
                }
                else{
                    if wishlisttype == "add"
                    {
                        var data = self.Trending_Products_Array[sender]
                        data["in_whishlist"]! = "true"
                        self.Trending_Products_Array.remove(at: sender)
                        self.Trending_Products_Array.insert(data, at: sender)
                        self.Collectionview_TrendingProducts.reloadData()
                    }
                    else
                    {
                        var data = self.Trending_Products_Array[sender]
                        data["in_whishlist"]! = "false"
                        self.Trending_Products_Array.remove(at: sender)
                        self.Trending_Products_Array.insert(data, at: sender)
                        self.Collectionview_TrendingProducts.reloadData()
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
    func Webservice_Cart(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
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
    func Webservice_RandomReview(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                self.Testimonials_Array = jsonResponse!["data"].arrayValue
                if self.Testimonials_Array.count == 0
                {
                    self.View_Testimonials.isHidden = true
                    self.HeightView_Testimonials.constant = 20.0
                }
                else{
                    self.View_Testimonials.isHidden = false
                    self.HeightView_Testimonials.constant = 380
                }
                self.Collectionview_Testimonial.delegate = self
                self.Collectionview_Testimonial.dataSource = self
                self.Collectionview_Testimonial.reloadData()
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
