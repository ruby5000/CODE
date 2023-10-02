import UIKit
import SwiftyJSON
import SDWebImage
import ImageSlideshow
import Cosmos
import iOSDropDown

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_text: UILabel!
    @IBOutlet weak var cell_view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class DescriptionListCell : UITableViewCell
{
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var btn_expand: UIButton!
    @IBOutlet weak var btnTap_title: UIButton!
}

class RattingsListCell : UICollectionViewCell
{
    @IBOutlet weak var lbl_Username: UILabel!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var lbl_reviews: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_subtitle: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_product: UIImageView!
    @IBOutlet weak var CosmosViews: CosmosView!
}

class TableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl_selectType: UILabel!
}

class DropdownCell : UITableViewCell
{
    @IBOutlet weak var lbl_selectSize: UILabel!
    @IBOutlet weak var txt_size: DropDown!
}

class ItemDetailsVC: UIViewController {
    
    @IBOutlet weak var Tableview_variantList: UITableView!
    @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
    
    @IBOutlet weak var Height_Collectionview: NSLayoutConstraint!
    @IBOutlet weak var Collectionview_RelatedproductsList: UICollectionView!
    
    
    @IBOutlet weak var Width_Addreview: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_currency: UILabel!
    @IBOutlet weak var lbl_discount_price: UILabel!
    @IBOutlet weak var lbl_categoryName: UILabel!
    
    @IBOutlet weak var Collectionview_RattingsList: UICollectionView!
    @IBOutlet weak var CosmosViews: CosmosView!
    @IBOutlet weak var image_Slider: ImageSlideshow!
    
    @IBOutlet weak var view_Rattings: UIView!
    @IBOutlet weak var Height_RattingsView: NSLayoutConstraint!
    
    @IBOutlet weak var Height_Tableviewdescripation: NSLayoutConstraint!
    @IBOutlet weak var Tableview_DescripationList: UITableView!
    @IBOutlet weak var btn_Addtocart: UIButton!
    
    @IBOutlet weak var lbl_ratingcount: UILabel!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var view_Empty: UIView!
    
    @IBOutlet weak var lbl_addtocart: UILabel!
    @IBOutlet weak var lbl_Outofstock: UILabel!
    @IBOutlet weak var lbl_returnstring: UILabel!
    @IBOutlet weak var btn_addreview: UIButton!
    @IBOutlet weak var Height_reletedProductView: NSLayoutConstraint!
    @IBOutlet weak var View_reletedProduct: UIView!
    
    var Desc_height = Double()
    var item_id = String()
    var isStock = String()
    var ItemSize = [String]()
    var Itemcolor = [String]()
    var product_Review_Array = [JSON]()
    var product_variant_Array = [JSON]()
    var product_varintValue_Array = [JSON]()
    var other_description_array = [[String:String]]()
    var RelatedProduct_array = [[String:String]]()
    var product_id = String()
    var productImages = [SDWebImageSource]()
    var SelectedVariation_Array = [String]()
    var isSelected_Size = String()
    var Selected_Variant_id = String()
    var Selected_Variant_Name = String()
    var ValuArray = [JSON]()
    var Guest_productinfoarray = [String:JSON]()
    var expandedCells = [Int]()
    var pageIndex = 1
    var lastIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_Outofstock.isHidden = true
        self.btn_addreview.isHidden = true
        cornerRadius(viewName: self.lbl_count, radius: self.lbl_count.frame.height / 2)
        self.Height_Tableview.constant = 0.0
        self.view_Rattings.isHidden = true
        self.Height_RattingsView.constant = 0.0
        self.view_Empty.isHidden = false
       // self.Width_Addreview.constant = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            self.btn_addreview.isHidden = true
            let urlString = API_URL + "product-detail-guest"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["id":self.item_id,"theme_id":APP_THEME]
            self.Webservice_ProductDetail(url: urlString, params: params, header: headers)
        }
        else{
            
            let urlString = API_URL + "product-detail"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["id":self.item_id,"theme_id":APP_THEME]
            self.Webservice_ProductDetail(url: urlString, params: params, header: headers)
        }
    }
    
    func imageSliderData() {
        self.image_Slider.slideshowInterval = 3.0
        self.image_Slider.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 10.0))
        self.image_Slider.contentScaleMode = UIView.ContentMode.scaleAspectFit
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
}
//MARK: Button Actions
extension ItemDetailsVC
{
    @IBAction func btnTap_More(_ sender: UIButton) {
        
        guard let url = URL(string: UserDefaultManager.getStringFromUserDefaults(key: UD_ReturnPolicyURL)) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func btnTap_Addreview(_ sender: UIButton) {
        let vc = MainstoryBoard.instantiateViewController(withIdentifier: "AddrattingsVC") as! AddrattingsVC
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        vc.product_id = item_id
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_Addtocart(_ sender: UIButton) {
        if self.isStock == "0"
        {
            
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else{
                print("Notify api calling")
                let urlString = API_URL + "notify_user"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":self.product_id,"theme_id":APP_THEME]
                self.Webservice_NotifyProduct(url: urlString, params: params, header: headers)
            }
            
        }
        else{
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                if UserDefaults.standard.value(forKey: UD_GuestObj) != nil
                {
                    var Guest_Array = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestObj) as! [[String:String]]
                    var iscart = false
                    var cartindex = Int()
                    for i in 0..<Guest_Array.count
                    {
                        if Guest_Array[i]["product_id"]! == self.Guest_productinfoarray["id"]!.stringValue && Guest_Array[i]["variant_id"]! == self.Selected_Variant_id
                        {
                            iscart = true
                            cartindex = i
                        }
                    }
                    if iscart == false
                    {
                        let cartobj = ["product_id": self.Guest_productinfoarray["id"]!.stringValue,
                                       "image": self.Guest_productinfoarray["cover_image_path"]!.stringValue,
                                       "name": self.Guest_productinfoarray["name"]!.stringValue,
                                       "orignal_price": self.Guest_productinfoarray["original_price"]!.stringValue,
                                       "discount_price": self.Guest_productinfoarray["discount_price"]!.stringValue,
                                       "final_price": self.Guest_productinfoarray["final_price"]!.stringValue,
                                       "qty": "1",
                                       "variant_id": self.Selected_Variant_id,
                                       "variant_name": self.Selected_Variant_Name]
                        Guest_Array.append(cartobj)
                        UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: Guest_Array, key: UD_GuestObj)
                        UserDefaultManager.setStringToUserDefaults(value: "\(Guest_Array.count)", key: UD_CartCount)
                        // showAlertMessage(titleStr: "", messageStr: CART_CONFIRM_MESAAGE)
                        
                        let alert = UIAlertController(title: nil, message: "\(self.Guest_productinfoarray["name"]!.stringValue) add successfully", preferredStyle: .alert)
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
                self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
            }
            else{
                let urlString = API_URL + "addtocart"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"variant_id":self.Selected_Variant_id,"qty":"1","product_id":self.product_id,"theme_id":APP_THEME]
                self.Webservice_Cart(url: urlString, params: params, header: headers)
            }
        }
    }
    
    @IBAction func btnTap_Cart(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ItemDetailsVC : FeedbackDelegate
{
    func refreshData(id: String, rating_no: String, title: String, description: String) {
        
        let urlString = API_URL + "product-rating"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["id":id,"user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"rating_no":rating_no,"title":title,"description":description,"theme_id":APP_THEME]
        self.Webservice_Productrating(url: urlString, params: params, header: headers)
        
    }
    
}
// MARK:- CollectionView Deleget methods
extension ItemDetailsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.Collectionview_RattingsList
        {
            return self.product_Review_Array.count
        }
        if collectionView == self.Collectionview_RelatedproductsList
        {
            return self.RelatedProduct_array.count
        }
        else
        {
            return self.ValuArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.Collectionview_RattingsList
        {
            let cell = self.Collectionview_RattingsList.dequeueReusableCell(withReuseIdentifier: "RattingsListCell", for: indexPath) as! RattingsListCell
            let data = self.product_Review_Array[indexPath.item]
            cell.lbl_title.text = data["title"].stringValue
            cell.lbl_subtitle.text = data["review"].stringValue
            cell.lbl_Username.text = data["user_name"].stringValue
            cell.lbl_rating.text = "\(data["rating"].stringValue).0 / 5.0"
            
            let original3 = IMG_URL + data["product_image"].stringValue
            if let encoded = original3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let url = URL(string: encoded)
            {
                cell.img_product.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            }
            
            cell.CosmosViews.rating = data["rating"].doubleValue
            return cell
        }
        else if collectionView == self.Collectionview_RelatedproductsList
        {
            let cell = self.Collectionview_RelatedproductsList.dequeueReusableCell(withReuseIdentifier: "featuredItemListCell", for: indexPath) as! featuredItemListCell
            let data = self.RelatedProduct_array[indexPath.item]
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
            cell.btn_favrites.addTarget(self, action: #selector(btnTapTopProduct_Like), for: .touchUpInside)
            cell.btn_cart.tag = indexPath.row
            cell.btn_cart.addTarget(self, action: #selector(btnTapTopProduct_Carts), for: .touchUpInside)
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            let data = self.ValuArray[indexPath.item]
            cell.lbl_text.text = data.stringValue
            cornerRadius(viewName: cell.cell_view, radius: cell.cell_view.frame.height / 2)
            
            if data.stringValue == self.SelectedVariation_Array[collectionView.tag]
            {
                cell.cell_view.backgroundColor = UIColor.init(named: "Second_Color")
                cell.lbl_text.textColor = UIColor.white
            }
            else{
                cell.cell_view.backgroundColor = UIColor.white
                cell.lbl_text.textColor = UIColor.black
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.Collectionview_RattingsList
        {
            return CGSize(width: (collectionView.bounds.size.width - 36), height: 275)
        }
        if collectionView == self.Collectionview_RelatedproductsList
        {
            return CGSize(width: (UIScreen.main.bounds.width - 54), height: 612)
        }
        else
        {
            return CGSize(width: 50, height: 50)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.Collectionview_RattingsList
        {
            
        }
        else if collectionView == self.Collectionview_RelatedproductsList
        {
            let data = self.RelatedProduct_array[indexPath.item]
            let vc = self.storyboard?.instantiateViewController(identifier: "ItemDetailsVC") as! ItemDetailsVC
            vc.item_id = data["id"]!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            self.SelectedVariation_Array.remove(at: collectionView.tag)
            self.SelectedVariation_Array.insert(self.product_variant_Array[collectionView.tag]["value"][indexPath.item].stringValue, at: collectionView.tag)
            self.Tableview_variantList.reloadData()
            let urlString = API_URL + "check-variant-stock"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["product_id":self.product_id,"variant_sku":self.SelectedVariation_Array.joined(separator: "-"),"theme_id":APP_THEME]
            self.Webservice_CheckVariantStock(url: urlString, params: params, header: headers)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,forItemAt indexPath: IndexPath)
    {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            if collectionView == self.Collectionview_RelatedproductsList
            {
                if indexPath.item == self.RelatedProduct_array.count - 1 {
                    if self.pageIndex != self.lastIndex {
                        self.pageIndex = self.pageIndex + 1
                        if self.RelatedProduct_array.count != 0 {
                            let urlString2 = API_URL + "releted-product-guest?page=\(self.pageIndex)"
                            let headers2:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                            let params2: NSDictionary = ["theme_id":APP_THEME,"product_id":self.product_id]
                            self.Webservice_RelatedProduct(url: urlString2, params: params2, header: headers2)
                        }
                    }
                }
            }
        }
        else{
            if collectionView == self.Collectionview_RelatedproductsList
            {
                if indexPath.item == self.RelatedProduct_array.count - 1 {
                    if self.pageIndex != self.lastIndex {
                        self.pageIndex = self.pageIndex + 1
                        if self.RelatedProduct_array.count != 0 {
                            let urlString2 = API_URL + "releted-product?page=\(self.pageIndex)"
                            let headers2:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                            let params2: NSDictionary = ["theme_id":APP_THEME,"product_id":self.product_id]
                            self.Webservice_RelatedProduct(url: urlString2, params: params2, header: headers2)
                        }
                    }
                }
            }
            
        }
    }
    @objc func btnTapTopProduct_Like(sender:UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            keyWindow?.rootViewController = nav
        }
        else{
            let data = self.RelatedProduct_array[sender.tag]
            if data["in_whishlist"]! == "false"
            {
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["id"]!,"wishlist_type":"add","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers, wishlisttype: "add", sender: sender.tag, isselect: "Related")
            }
            else if data["in_whishlist"]! == "true"
            {
                let urlString = API_URL + "wishlist"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["id"]!,"wishlist_type":"remove","theme_id":APP_THEME]
                self.Webservice_wishlist(url: urlString, params: params, header: headers, wishlisttype: "remove",sender: sender.tag, isselect: "Related")
            }
        }
    }
    @objc func btnTapTopProduct_Carts(sender:UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let data = RelatedProduct_array[sender.tag]
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
            let data = RelatedProduct_array[sender.tag]
            self.product_id = data["id"]!
            self.Selected_Variant_id = data["default_variant_id"]!
            let urlString = API_URL + "addtocart"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"variant_id":data["default_variant_id"]!,"qty":"1","product_id":data["id"]!,"theme_id":APP_THEME]
            self.Webservice_Cart(url: urlString, params: params, header: headers)
            
        }
    }
    
}
//MARK: Tableview Methods
extension ItemDetailsVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.Tableview_variantList
        {
            return self.product_variant_Array.count
        }
        else{
            return self.other_description_array.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.Tableview_variantList
        {
            return 120
        }
        else{
            
            if self.other_description_array[indexPath.row]["is_selected"] == "0"{
                //                return 45
                let height = self.other_description_array[indexPath.row]["description"]!.height(withConstrainedWidth: UIScreen.main.bounds.width - 36, font: UIFont(name: "Outfit-Medium", size: 14)!) + 16.0 + 45.0
                return height
            }
            else {
                let height = self.other_description_array[indexPath.row]["description"]!.height(withConstrainedWidth: UIScreen.main.bounds.width - 36, font: UIFont(name: "Outfit-Medium", size: 14)!) + 16.0 + 45.0
                return height
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.Tableview_variantList
        {
            let data = self.product_variant_Array[indexPath.row]
            if data["type"].stringValue == "dropdown"
            {
                let cell = self.Tableview_variantList.dequeueReusableCell(withIdentifier: "DropdownCell") as! DropdownCell
                cell.lbl_selectSize.text = "Select \(data["name"].stringValue):"
                cell.txt_size.text = self.SelectedVariation_Array[indexPath.row]
                cell.txt_size.placeholder = "Select \(data["name"].stringValue):"
                cell.txt_size.tag = indexPath.row
                cell.txt_size.addTarget(self, action: #selector(ItemDetailsVC.textFieldDidChange(_:)),
                                        for: .editingDidBegin)
                return cell
            }
            else{
                let cell = self.Tableview_variantList.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
                cell.lbl_selectType.text = "Select \(data["name"].stringValue):"
                self.ValuArray = data["value"].arrayValue
                cell.collectionView.tag = indexPath.row
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.reloadData()
                return cell
            }
        }
        else
        {
            let cell = self.Tableview_DescripationList.dequeueReusableCell(withIdentifier: "DescriptionListCell") as! DescriptionListCell
            let data = self.other_description_array[indexPath.row]
            cell.lbl_title.text = data["title"]!
            cell.lbl_desc.text = data["description"]!
            
            if  data["is_selected"]! == "0"
            {
                cell.btn_expand.setTitle("+", for: .normal)
            }
            else
            {
                cell.btn_expand.setTitle("-", for: .normal)
            }
            
            cell.btn_expand.tag = indexPath.row
            cell.btn_expand.addTarget(self, action: #selector(btnTap_expand), for: .touchUpInside)
            
            cell.btnTap_title.tag = indexPath.row
            cell.btnTap_title.addTarget(self, action: #selector(btnTap_expand), for: .touchUpInside)
            
            return cell
        }
        
    }
    
}
//MARK: Button Action
extension ItemDetailsVC
{
    @objc func btnTap_expand(sender:UIButton) {
        var data = self.other_description_array[sender.tag]
        
        if data["is_selected"]! == "0"
        {
            data["is_selected"]! = "1"
        }
        else{
            data["is_selected"]! = "0"
        }
        self.other_description_array.remove(at: sender.tag)
        self.other_description_array.insert(data, at: sender.tag)
        Desc_height = 0.0
        for maindata in self.other_description_array
        {
            if maindata["is_selected"]! == "0"
            {
                //                Desc_height = Desc_height + 45.0
                let height = maindata["description"]!.height(withConstrainedWidth: UIScreen.main.bounds.width - 36, font: UIFont(name: "Outfit-Medium", size: 14)!) + 16.0 + 45.0
                Desc_height = Desc_height + height
            }
            else{
                let height = maindata["description"]!.height(withConstrainedWidth: UIScreen.main.bounds.width - 36, font: UIFont(name: "Outfit-Medium", size: 14)!) + 16.0 + 45.0
                Desc_height = Desc_height + height
            }
            
        }
        self.Tableview_DescripationList.reloadData()
        self.Height_Tableviewdescripation.constant = Desc_height
        
    }
    @objc func textFieldDidChange(_ textField: DropDown) {
        let data = self.product_variant_Array[textField.tag]
        self.Itemcolor.removeAll()
        for valuearray in data["value"].arrayValue
        {
            self.Itemcolor.append(valuearray.stringValue)
        }
        textField.textColor = UIColor.init(named: "Primary_Color")
        textField.checkMarkEnabled = false
        textField.resignFirstResponder()
        textField.isSearchEnable = false
        textField.optionArray = Itemcolor
        textField.selectedRowColor = UIColor.init(named: "White_light")!
        textField.rowBackgroundColor  = UIColor.init(named: "White_light")!
        textField.itemsColor = UIColor.init(named: "Primary_Color")!
        textField.didSelect { selectedText, index, id in
            
            print(selectedText)
            self.SelectedVariation_Array.remove(at: textField.tag)
            self.SelectedVariation_Array.insert(selectedText, at: textField.tag)
            self.Tableview_variantList.reloadData()
            let urlString = API_URL + "check-variant-stock"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["product_id":self.product_id,"variant_sku":self.SelectedVariation_Array.joined(separator: "-"),"theme_id":APP_THEME]
            self.Webservice_CheckVariantStock(url: urlString, params: params, header: headers)
        }
    }
}
//MARK: Api calling Funcations
extension ItemDetailsVC
{
    func Webservice_ProductDetail(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) { [self](_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"]["product_info"].dictionaryValue
                self.Guest_productinfoarray = jsondata
                self.lbl_name.text = jsondata["name"]!.stringValue
                self.lbl_categoryName.text = jsondata["category_name"]!.stringValue
                self.lbl_currency.text = UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name)
                
                self.CosmosViews.rating = jsondata["average_rating"]!.doubleValue
                self.product_id = jsondata["id"]!.stringValue
                
                self.product_Review_Array = jsonResponse!["data"]["product_Review"].arrayValue
                
               
                
                self.product_variant_Array = jsonResponse!["data"]["variant"].arrayValue
                self.lbl_ratingcount.text = "\(jsondata["average_rating"]!.stringValue).0 / 5.0"
                if jsondata["is_review"]! == 1
                {
                    self.btn_addreview.isHidden = true
                }
                else if jsondata["is_review"]! == 0
                {
                    if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
                    {
                        self.btn_addreview.isHidden = true
                    }
                    else{
                        self.btn_addreview.isHidden = false
                    }
                }
                
                self.lbl_returnstring.text = jsondata["retuen_text"]!.stringValue
                self.other_description_array.removeAll()
                for data in jsondata["other_description_array"]!.arrayValue
                {
                    if data["description"].stringValue != ""
                    {
                        print(data["title"].stringValue)
                        let obj = ["description":data["description"].stringValue,"title":data["title"].stringValue,"is_selected":"0"]
                        self.other_description_array.append(obj)
                    }
                }
                if self.other_description_array.count != 0
                {
                    var data = self.other_description_array[0]
                    data["is_selected"] = "1"
                    self.other_description_array.remove(at: 0)
                    self.other_description_array.insert(data, at: 0)
                }
                if self.product_variant_Array.count != 0
                {
                    self.Height_Tableview.constant = CGFloat(self.product_variant_Array.count * 120)
                    self.SelectedVariation_Array.removeAll()
                    for data in self.product_variant_Array
                    {
                        if data["value"].arrayValue.count != 0
                        {
                            
                            self.SelectedVariation_Array.append(data["value"][0].stringValue)
                        }
                    }
                    let urlString = API_URL + "check-variant-stock"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["product_id":self.product_id,"variant_sku":self.SelectedVariation_Array.joined(separator: "-"),"theme_id":APP_THEME]
                    self.Webservice_CheckVariantStock(url: urlString, params: params, header: headers)
                }
                else{
                    
                    self.Height_Tableview.constant = 0.0
                    let discount_ItemPrice = formatter.string(for: jsondata["original_price"]!.stringValue.toDouble)
                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(discount_ItemPrice!)")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
                    self.lbl_discount_price.attributedText = attributeString
                    let ItemPrice = formatter.string(for: jsondata["final_price"]!.stringValue.toDouble)
                    self.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
                    self.Selected_Variant_id = "0"
                    self.isStock = jsondata["product_stock"]!.stringValue
                    if jsondata["product_stock"]!.stringValue == "0"
                    {
                        self.lbl_Outofstock.isHidden = false
                        self.lbl_addtocart.text = "Notify me when available"
                    }
                    else{
                        self.lbl_addtocart.text = "Add to cart"
                        self.lbl_Outofstock.isHidden = true
                    }
                }
                
                if self.product_Review_Array.count != 0
                {
                    self.view_Rattings.isHidden = false
                    self.Height_RattingsView.constant = 350
                   // self.Width_Addreview.constant = 100.0
                }
                else{
                    self.view_Rattings.isHidden = true
                    self.Height_RattingsView.constant = 0.0
                   // self.Width_Addreview.constant = 0.0
                }
                
                self.Tableview_variantList.delegate = self
                self.Tableview_variantList.dataSource = self
                self.Tableview_variantList.reloadData()
            
                self.Collectionview_RattingsList.delegate = self
                self.Collectionview_RattingsList.dataSource = self
                self.Collectionview_RattingsList.reloadData()
                
                self.Tableview_DescripationList.delegate = self
                self.Tableview_DescripationList.dataSource = self
                self.Tableview_DescripationList.reloadData()
                
                self.Desc_height = 0.0
                for maindata in self.other_description_array
                {
                    if maindata["is_selected"]! == "0"
                    {
                        let height = maindata["description"]!.height(withConstrainedWidth: UIScreen.main.bounds.width - 36, font: UIFont(name: "Outfit-Medium", size: 14)!) + 16.0 + 45.0
                        self.Desc_height = self.Desc_height + height
                    }
                    else{
                        let height = maindata["description"]!.height(withConstrainedWidth: UIScreen.main.bounds.width - 36, font: UIFont(name: "Outfit-Medium", size: 14)!) + 16.0 + 45.0
                        self.Desc_height = self.Desc_height + height
                    }
                }
                self.Height_Tableviewdescripation.constant = self.Desc_height
                self.productImages.removeAll()
                
                let productImages = jsonResponse!["data"]["product_image"].arrayValue
                for image in productImages
                {
                    let endpoint = IMG_URL + image["image_path"].stringValue
                    if let encoded = endpoint.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                       let url = URL(string: encoded)
                    {
                        let imageSource = SDWebImageSource(url: url, placeholder: UIImage(named: ""))
                        self.productImages.append(imageSource)
                    }
                }
                self.imageSliderData()
 
                
                if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""  {
                    self.pageIndex = 1
                    self.lastIndex = 0
                    let urlString2 = API_URL + "releted-product-guest?page=\(self.pageIndex)"
                    let headers2:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params2: NSDictionary = ["theme_id":APP_THEME,"product_id":self.product_id]
                    self.Webservice_RelatedProduct(url: urlString2, params: params2, header: headers2)
                }
                else {
                    self.pageIndex = 1
                    self.lastIndex = 0
                    let urlString2 = API_URL + "releted-product?page=\(self.pageIndex)"
                    let headers2:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params2: NSDictionary = ["theme_id":APP_THEME,"product_id":self.product_id]
                    self.Webservice_RelatedProduct(url: urlString2, params: params2, header: headers2)
                }
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
    // MARK: - Cart api calling
    func Webservice_Cart(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
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
    // MARK: - checkVariantStock
    func Webservice_CheckVariantStock(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
                let jsondata = jsonResponse!["data"].dictionaryValue
                let discount_ItemPrice = formatter.string(for: jsondata["original_price"]!.stringValue.toDouble)
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(discount_ItemPrice!)")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
                self.lbl_discount_price.attributedText = attributeString
                let ItemPrice = formatter.string(for: jsondata["final_price"]!.stringValue.toDouble)
                self.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
                self.Selected_Variant_id = jsondata["id"]!.stringValue
                self.Selected_Variant_Name = jsondata["variant"]!.stringValue
                self.isStock = jsondata["stock"]!.stringValue
                if jsondata["stock"]!.stringValue == "0" {
                    self.lbl_Outofstock.isHidden = false
                    self.lbl_addtocart.text = "Notify me when available"
                }
                else {
                    self.lbl_addtocart.text = "Add to cart"
                    self.lbl_Outofstock.isHidden = true
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
    // MARK: - productRating api
    func Webservice_Productrating(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
                if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" {
                    let urlString = API_URL + "product-detail-guest"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["id":self.item_id,"theme_id":APP_THEME]
                    self.Webservice_ProductDetail(url: urlString, params: params, header: headers)
                }
                else {
                    let urlString = API_URL + "product-detail"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["id":self.item_id,"theme_id":APP_THEME]
                    self.Webservice_ProductDetail(url: urlString, params: params, header: headers)
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
    // MARK: - CartQty api calling
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
    // MARK: - NotifyProduct api calling
    func Webservice_NotifyProduct(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
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
    // MARK: - RelatedProduct
    func Webservice_RelatedProduct(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
                let jsondata = jsonResponse!["data"].dictionaryValue
                
                if self.pageIndex == 1 {
                    self.lastIndex = Int(jsondata["last_page"]!.stringValue)!
                    self.RelatedProduct_array.removeAll()
                }
                let Featuredprodcutdata = jsondata["data"]!.arrayValue
                for data in Featuredprodcutdata  {
                    let productObj = ["id":data["id"].stringValue,"name":data["name"].stringValue,"tag_api":data["tag_api"].stringValue,"cover_image_path":data["cover_image_path"].stringValue,"final_price":data["final_price"].stringValue,"in_whishlist":data["in_whishlist"].stringValue,"default_variant_id":data["default_variant_id"].stringValue,"orignal_price":data["original_price"].stringValue,"discount_price":data["discount_price"].stringValue,"variant_name":data["default_variant_name"].stringValue,"original_price":data["original_price"].stringValue,"discount_type":data["discount_type"].stringValue,"average_rating":data["average_rating"].stringValue,"average_ratings":data["average_rating"].stringValue]
                    self.RelatedProduct_array.append(productObj)
                }
                self.Collectionview_RelatedproductsList.delegate = self
                self.Collectionview_RelatedproductsList.dataSource = self
                self.Collectionview_RelatedproductsList.reloadData()
                
                if self.RelatedProduct_array.count != 0 {
                    self.View_reletedProduct.isHidden = false
                    self.Height_reletedProductView.constant = 692
                } else {
                    self.View_reletedProduct.isHidden = true
                    self.Height_reletedProductView.constant = 0.0
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
    
    // MARK: - wishlist api calling
    func Webservice_wishlist(url:String, params:NSDictionary,header:NSDictionary,wishlisttype:String,sender:Int,isselect:String) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
                if isselect == "Related" {
                    if wishlisttype == "add" {
                        var data = self.RelatedProduct_array[sender]
                        data["in_whishlist"]! = "true"
                        self.RelatedProduct_array.remove(at: sender)
                        self.RelatedProduct_array.insert(data, at: sender)
                        self.Collectionview_RelatedproductsList.reloadData()
                    }
                    else {
                        var data = self.RelatedProduct_array[sender]
                        data["in_whishlist"]! = "false"
                        self.RelatedProduct_array.remove(at: sender)
                        self.RelatedProduct_array.insert(data, at: sender)
                        self.Collectionview_RelatedproductsList.reloadData()
                    }
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
}

// MARK: - String
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}
