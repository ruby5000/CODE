//
//  CartVC.swift
//  Fashion
//
//  Created by Gravityinfotech on 24/03/22.
//

import UIKit
import SwiftyJSON

class TaxinfoCell : UICollectionViewCell
{
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
}
class CartListCell : UITableViewCell
{
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var img_products: UIImageView!
    @IBOutlet weak var btn_pluse: UIButton!
    @IBOutlet weak var btn_Minus: UIButton!
    @IBOutlet weak var lbl_qty: UILabel!
    @IBOutlet weak var lbl_size: UILabel!
    @IBOutlet weak var btn_returnItem: UIButton!
}

class CartVC: UIViewController {
    
    @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
    @IBOutlet weak var Tableview_CartList: UITableView!
    @IBOutlet weak var lbl_subtotal: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_totalproducts: UILabel!
    @IBOutlet weak var lbl_cartotal: UILabel!
    @IBOutlet weak var txt_Promocode: UITextField!
    @IBOutlet weak var Collectionview_Taxinfo: UICollectionView!
    @IBOutlet weak var View_CouponCode: UIView!
    @IBOutlet weak var view_total: UIView!
    @IBOutlet weak var lbl_couponcode: UILabel!
    @IBOutlet weak var lbl_DiscountAmoint: UILabel!
    @IBOutlet weak var lbl_Nodata: UILabel!
    @IBOutlet weak var lbl_totalcart: UILabel!
    @IBOutlet weak var view_Empty: UIView!
    
    var Cartlist_Array = [JSON]()
    var Taxinfo_Array = [JSON]()
    var GuestCartList_Array = [[String:String]]()
    var sub_total = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius(viewName: self.lbl_totalcart, radius: 8.0)
        self.lbl_Nodata.isHidden = true
        self.View_CouponCode.isHidden = true
        self.view_total.isHidden = true
        self.lbl_couponcode.isHidden = true
        self.lbl_DiscountAmoint.isHidden = true
        self.View_CouponCode.isHidden = true
        self.view_total.isHidden = true
    }
    
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_Apply(_ sender: UIButton) {
        if self.txt_Promocode.text == ""
        {
            showAlertMessage(titleStr: "", messageStr: PROMOCODE_MESAAGE)
        }
        else{
            let urlString = API_URL + "apply-coupon"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["coupon_code":self.txt_Promocode.text!,"sub_total":self.sub_total,"theme_id":APP_THEME]
            self.Webservice_CheckCoupon(url: urlString, params: params, header: headers)
        }
    }
    
    @IBAction func btnTap_CheckOut(_ sender: UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            if UserDefaults.standard.value(forKey: UD_GuestObj) != nil
            {
                let Guest_Array = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestObj) as! [[String:String]]
                self.GuestCartList_Array = Guest_Array
                
                var productArray = [[String:String]]()
                var TaxArray = [[String:String]]()
                
                for productdata in self.GuestCartList_Array
                {
                    let productobj = ["product_id":productdata["product_id"]!,"qty":productdata["qty"]!,"variant_id":productdata["variant_id"]!]
                    productArray.append(productobj)
                }
                UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: productArray, key: UD_GuestProductArray)
                for Taxinfodata in self.Taxinfo_Array
                {
                    let Taxobj = ["id":Taxinfodata["id"].stringValue,"tax_string":Taxinfodata["tax_string"].stringValue,"tax_price":Taxinfodata["tax_price"].stringValue,"tax_amount":Taxinfodata["tax_amount"].stringValue,"tax_type":Taxinfodata["tax_type"].stringValue,"tax_name":Taxinfodata["tax_name"].stringValue]
                    TaxArray.append(Taxobj)
                }
                UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: TaxArray, key: UD_GuestTaxArray)
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Guest_BillingDetailsVC") as! Guest_BillingDetailsVC
//                self.navigationController?.pushViewController(vc, animated: true)
                
                let alert = UIAlertController(title:Bundle.main.displayName!, message: "", preferredStyle: .alert)
                let photoLibraryAction = UIAlertAction(title: "Countinue as guest", style: .default) { (action) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Guest_BillingDetailsVC") as! Guest_BillingDetailsVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                let cameraAction = UIAlertAction(title: "Countinue to sign in", style: .default) { (action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                    let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                    nav.navigationBar.isHidden = true
                    keyWindow?.rootViewController = nav

                }
                //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(photoLibraryAction)
                alert.addAction(cameraAction)
                //alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        else
        {
            let urlString = API_URL + "cart-check"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
            self.Webservice_CartCheck(url: urlString, params: params, header: headers)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view_Empty.isHidden = false
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            if UserDefaults.standard.value(forKey: UD_GuestObj) != nil
            {
                let Guest_Array = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestObj) as! [[String:String]]
                self.GuestCartList_Array = Guest_Array
                
                var Total = Double()
                var QtyTotal = Int()
                for totalprice in GuestCartList_Array
                {
                    Total = Total + (Double(totalprice["final_price"]!)! * Double(totalprice["qty"]!)!)
                    QtyTotal = QtyTotal + Int(totalprice["qty"]!)!
                }
                self.lbl_totalcart.text = "\(QtyTotal)"
                let ItemPrice = formatter.string(for: "\(Total)".toDouble)?.replacingOccurrences(of: ",", with: "")
                let urlString = API_URL + "tax-guest"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["sub_total":"\(ItemPrice!)","theme_id":APP_THEME]
                self.Webservice_TaxGuest(url: urlString, params: params, header: headers)
                
            }
        }
        else{
            let urlString = API_URL + "cart-list"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
            self.Webservice_CartList(url: urlString, params: params, header: headers)
        }
        
    }
    
}
//MARK: Tableview Methods
extension CartVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            if self.GuestCartList_Array.count == 0
            {
                self.lbl_Nodata.isHidden = false
            }
            else{
                self.lbl_Nodata.isHidden = true
                return self.GuestCartList_Array.count
            }
        }
        else{
            if self.Cartlist_Array.count == 0
            {
                self.lbl_Nodata.isHidden = false
            }
            else{
                self.lbl_Nodata.isHidden = true
                return self.Cartlist_Array.count
            }
            
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.Tableview_CartList.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell
        
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let data = GuestCartList_Array[indexPath.row]
            let ItemPrice = formatter.string(for: data["final_price"]!.toDouble)
            let TotalItemPrice = Double(ItemPrice!.replacingOccurrences(of: ",", with: ""))! * Double("\(data["qty"]!)")!
            let ItemPricetotal = formatter.string(for: "\(TotalItemPrice)".toDouble)
            
            cell.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPricetotal!)"
            let original3 = IMG_URL + data["image"]!
            if let encoded = original3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let url = URL(string: encoded)
            {
                cell.img_products.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            }
            cell.lbl_name.text = data["name"]!
            cell.lbl_size.text = data["variant_name"]!
            cell.lbl_qty.text = data["qty"]!
            
            if Int(data["qty"]!)! <= 1 {
                cell.btn_Minus.isEnabled = false
            }
            else {
                cell.btn_Minus.isEnabled = true
            }
            cell.btn_Minus.tag = indexPath.row
            cell.btn_Minus.addTarget(self, action: #selector(btnTapMines), for: .touchUpInside)
            cell.btn_pluse.tag = indexPath.row
            cell.btn_pluse.addTarget(self, action: #selector(btnTapPluse), for: .touchUpInside)
            return cell
        }
        else
        {
            let data = Cartlist_Array[indexPath.row]
            let ItemPrice = formatter.string(for: data["final_price"].stringValue.toDouble)
            cell.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!) "
            
            let original3 = IMG_URL + data["image"].stringValue
            if let encoded = original3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let url = URL(string: encoded)
            {
                cell.img_products.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            }
                
            cell.lbl_name.text = data["name"].stringValue
            cell.lbl_qty.text = data["qty"].stringValue
            cell.lbl_size.text = data["variant_name"].stringValue
            
            if Int(data["qty"].stringValue)! <= 1 {
                cell.btn_Minus.isEnabled = false
            }
            else {
                cell.btn_Minus.isEnabled = true
            }
            cell.btn_Minus.tag = indexPath.row
            cell.btn_Minus.addTarget(self, action: #selector(btnTapMines), for: .touchUpInside)
            cell.btn_pluse.tag = indexPath.row
            cell.btn_pluse.addTarget(self, action: #selector(btnTapPluse), for: .touchUpInside)
            return cell
            
        }
        
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
                if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
                {
                    if UserDefaults.standard.value(forKey: UD_GuestObj) != nil
                    {
                        var GuestCartData = [[String : String]]()
                        GuestCartData = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestObj) as! [[String:String]]
                        GuestCartData.remove(at:indexPath.row)
                        UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: GuestCartData, key: UD_GuestObj)
                        self.GuestCartList_Array = GuestCartData
                        UserDefaultManager.setStringToUserDefaults(value: "\(self.GuestCartList_Array.count)", key: UD_CartCount)
                        var Total = Double()
                        var QtyTotal = Int()
                        for totalprice in self.GuestCartList_Array
                        {
                            Total = Total + (Double(totalprice["final_price"]!)! * Double(totalprice["qty"]!)!)
                            QtyTotal = QtyTotal + Int(totalprice["qty"]!)!
                        }
                        self.lbl_totalcart.text = "\(QtyTotal)"
                        let ItemPrice = formatter.string(for: "\(Total)".toDouble)?.replacingOccurrences(of: ",", with: "")
                        let urlString = API_URL + "tax-guest"
                        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                        let params: NSDictionary = ["sub_total":"\(ItemPrice!)","theme_id":APP_THEME]
                        self.Webservice_TaxGuest(url: urlString, params: params, header: headers)
                    }
                }
                else{
                    let data = self.Cartlist_Array[indexPath.row]
                    let urlString = API_URL + "cart-qty"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    // quantity_type :- increase | decrease | remove (remove from cart)
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["product_id"].stringValue,"variant_id":data["variant_id"].stringValue,"quantity_type":"remove","theme_id":APP_THEME]
                    self.Webservice_CartQty(url: urlString, params: params, header: headers)
                }
                
            }
        )
        deleteAction.image = UISwipeActionsConfiguration.makeTitledImage(
            image: UIImage(named: "ic_trash"),
            title: "")
        deleteAction.backgroundColor = UIColor.init(named: "White_light")!
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    @objc func btnTapMines(sender:UIButton) {
        
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            if UserDefaults.standard.value(forKey: UD_GuestObj) != nil
            {
                var GuestCartData = [[String : String]]()
                GuestCartData = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestObj) as! [[String:String]]
                var cartobject = GuestCartData[sender.tag]
                var qty = Int(cartobject["qty"]!)
                qty = qty! - 1
                cartobject["qty"]! = "\(qty!)"
                GuestCartData.remove(at: sender.tag)
                GuestCartData.insert(cartobject, at: sender.tag)
                
                UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: GuestCartData, key: UD_GuestObj)
                self.GuestCartList_Array = GuestCartData
                var Total = Double()
                var QtyTotal = Int()
                for totalprice in GuestCartList_Array
                {
                    Total = Total + (Double(totalprice["final_price"]!)! * Double(totalprice["qty"]!)!)
                    QtyTotal = QtyTotal + Int(totalprice["qty"]!)!
                }
                self.lbl_totalcart.text = "\(QtyTotal)"
                let ItemPrice = formatter.string(for: "\(Total)".toDouble)?.replacingOccurrences(of: ",", with: "")
                let urlString = API_URL + "tax-guest"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["sub_total":"\(ItemPrice!)","theme_id":APP_THEME]
                self.Webservice_TaxGuest(url: urlString, params: params, header: headers)
            }
            
        }
        else{
            let data = Cartlist_Array[sender.tag]
            let urlString = API_URL + "cart-qty"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            // quantity_type :- increase | decrease | remove (remove from cart)
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["product_id"].stringValue,"variant_id":data["variant_id"].stringValue,"quantity_type":"decrease","theme_id":APP_THEME]
            self.Webservice_CartQty(url: urlString, params: params, header: headers)
        }
        
        
    }
    
    @objc func btnTapPluse(sender:UIButton) {
        
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            if UserDefaults.standard.value(forKey: UD_GuestObj) != nil
            {
                var GuestCartData = [[String : String]]()
                GuestCartData = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestObj) as! [[String:String]]
                var cartobject = GuestCartData[sender.tag]
                var qty = Int(cartobject["qty"]!)
                qty = qty! + 1
                cartobject["qty"]! = "\(qty!)"
                GuestCartData.remove(at: sender.tag)
                GuestCartData.insert(cartobject, at: sender.tag)
                
                UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: GuestCartData, key: UD_GuestObj)
                self.GuestCartList_Array = GuestCartData
                var Total = Double()
                var QtyTotal = Int()
                for totalprice in GuestCartList_Array
                {
                    Total = Total + (Double(totalprice["final_price"]!)! * Double(totalprice["qty"]!)!)
                    QtyTotal = QtyTotal + Int(totalprice["qty"]!)!
                }
                self.lbl_totalcart.text = "\(QtyTotal)"
                let ItemPrice = formatter.string(for: "\(Total)".toDouble)?.replacingOccurrences(of: ",", with: "")
                let urlString = API_URL + "tax-guest"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["sub_total":"\(ItemPrice!)","theme_id":APP_THEME]
                self.Webservice_TaxGuest(url: urlString, params: params, header: headers)
            }
            
        }
        else
        {
            let data = Cartlist_Array[sender.tag]
            let urlString = API_URL + "cart-qty"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            // quantity_type :- increase | decrease | remove (remove from cart)
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"product_id":data["product_id"].stringValue,"variant_id":data["variant_id"].stringValue,"quantity_type":"increase","theme_id":APP_THEME]
            self.Webservice_CartQty(url: urlString, params: params, header: headers)
        }
        
    }
}
extension UISwipeActionsConfiguration {
    
    public static func makeTitledImage(
        image: UIImage?,
        title: String,
        textColor: UIColor = UIColor.white,
        font: UIFont = UIFont.systemFont(ofSize: 0.0),
        size: CGSize = .init(width: 50, height: 50)
    ) -> UIImage? {
        
        /// Create attributed string attachment with image
        let attachment = NSTextAttachment()
        attachment.image = image
        let imageString = NSAttributedString(attachment: attachment)
        
        /// Create attributed string with title
        let text = NSAttributedString(
            string: "\n\(title)",
            attributes: [
                .foregroundColor: textColor,
                .font: font
            ]
        )
        
        /// Merge two attributed strings
        let mergedText = NSMutableAttributedString()
        mergedText.append(imageString)
        mergedText.append(text)
        
        /// Create label and append that merged attributed string
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.textAlignment = .center
        label.numberOfLines = 2
        label.attributedText = mergedText
        
        /// Create image from that label
        let renderer = UIGraphicsImageRenderer(bounds: label.bounds)
        let image = renderer.image { rendererContext in
            label.layer.render(in: rendererContext.cgContext)
        }
        
        /// Convert it to UIImage and return
        if let cgImage = image.cgImage {
            return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        }
        
        return nil
    }
    
}
// MARK:- CollectionView Deleget methods
extension CartVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Taxinfo_Array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.Collectionview_Taxinfo.dequeueReusableCell(withReuseIdentifier: "TaxinfoCell", for: indexPath) as! TaxinfoCell
        let data = self.Taxinfo_Array[indexPath.item]
        cell.lbl_title.text = data["tax_string"].stringValue
        let ItemPrice = formatter.string(for: data["tax_price"].stringValue.toDouble)
        cell.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize(width: (UIScreen.main.bounds.width - 54) / 2, height: ((UIScreen.main.bounds.width - 54) / 2) + 60)
        return CGSize(width: 100, height: 40)
    }
}
extension CartVC
{
    func Webservice_CartList(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                self.Cartlist_Array = jsondata["product_list"]!.arrayValue
                self.Tableview_CartList.delegate = self
                self.Tableview_CartList.dataSource = self
                self.Tableview_CartList.reloadData()
                self.Height_Tableview.constant = CGFloat(self.Cartlist_Array.count * 95)
                self.Taxinfo_Array = jsondata["tax_info"]!.arrayValue
                self.lbl_totalcart.text = "\(jsondata["cart_total_qty"]!.stringValue)"
                
                let FinaltotalPrice = formatter.string(for: jsondata["final_price"]!.stringValue.toDouble)
                let SubtotalPrice = formatter.string(for: jsondata["sub_total"]!.stringValue.toDouble)
                self.sub_total = jsondata["sub_total"]!.stringValue
                self.lbl_subtotal.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(SubtotalPrice!)"
                self.lbl_total.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(FinaltotalPrice!)"
               // self.lbl_cartotal.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(FinaltotalPrice!)"
                //                self.lbl_totalproducts.text = "(\(CartArray.count) products)"
                self.View_CouponCode.isHidden = false
                self.view_total.isHidden = false
                
                if self.Taxinfo_Array.count == 2
                {
                    self.Collectionview_Taxinfo.isScrollEnabled = false
                }
                else{
                    self.Collectionview_Taxinfo.isScrollEnabled = true
                }
                
                if self.Cartlist_Array.count == 0
                {
                    self.View_CouponCode.isHidden = true
                    self.view_total.isHidden = true
                }
                else
                {
                    self.View_CouponCode.isHidden = false
                    self.view_total.isHidden = false
                }
                self.Collectionview_Taxinfo.delegate = self
                self.Collectionview_Taxinfo.dataSource = self
                self.Collectionview_Taxinfo.reloadData()
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
                self.Cartlist_Array.removeAll()
                self.Tableview_CartList.delegate = self
                self.Tableview_CartList.dataSource = self
                self.Tableview_CartList.reloadData()
                self.View_CouponCode.isHidden = true
                self.view_total.isHidden = true
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
                
                let urlString = API_URL + "cart-list"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
                self.Webservice_CartList(url: urlString, params: params, header: headers)
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
    
    func Webservice_CheckCoupon(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                let couponObj = ["coupon_id":jsondata["id"]!.stringValue,"coupon_name":jsondata["name"]!.stringValue,"coupon_code":jsondata["code"]!.stringValue,"coupon_discount_type":jsondata["coupon_discount_type"]!.stringValue,"coupon_discount_amount":jsondata["coupon_discount_amount"]!.stringValue,"coupon_final_amount":jsondata["amount"]!.stringValue,"coupon_discount_number":jsondata["amount"]!.stringValue]
                
                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: couponObj , key: UD_CouponObj)
                let FinaltotalPrice = formatter.string(for: jsondata["final_price"]!.stringValue.toDouble)
                let SubtotalPrice = formatter.string(for: jsondata["original_price"]!.stringValue.toDouble)
                let DiscountPrice = formatter.string(for: jsondata["coupon_discount_amount"]!.stringValue.toDouble)
                
                self.lbl_subtotal.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(SubtotalPrice!)"
                self.lbl_total.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(FinaltotalPrice!)"
                self.lbl_DiscountAmoint.text = "-\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(DiscountPrice!)"
                
                UserDefaultManager.setStringToUserDefaults(value: self.lbl_subtotal.text!, key: UD_GuestSubtotal)
                UserDefaultManager.setStringToUserDefaults(value: self.lbl_total.text!, key: UD_GuestFinaltotal)
                
                self.lbl_couponcode.isHidden = false
                self.lbl_DiscountAmoint.isHidden = false
                
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
                self.lbl_couponcode.isHidden = true
                self.lbl_DiscountAmoint.isHidden = true
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    func Webservice_CartCheck(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BillingDetailsVC") as! BillingDetailsVC
                self.navigationController?.pushViewController(vc, animated: true)
                
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
                self.lbl_couponcode.isHidden = true
                self.lbl_DiscountAmoint.isHidden = true
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    func Webservice_TaxGuest(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                self.Taxinfo_Array = jsondata["tax_info"]!.arrayValue
                
                let FinaltotalPrice = formatter.string(for: jsondata["final_price"]!.stringValue.toDouble)
                let SubtotalPrice = formatter.string(for: jsondata["original_price"]!.stringValue.toDouble)
                self.sub_total = jsondata["original_price"]!.stringValue
                self.lbl_subtotal.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(SubtotalPrice!)"
                self.lbl_total.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(FinaltotalPrice!)"
               // self.lbl_cartotal.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(FinaltotalPrice!)"
                UserDefaultManager.setStringToUserDefaults(value: self.lbl_subtotal.text!, key: UD_GuestSubtotal)
                UserDefaultManager.setStringToUserDefaults(value: self.lbl_total.text!, key: UD_GuestFinaltotal)
                
                if self.Taxinfo_Array.count == 2
                {
                    self.Collectionview_Taxinfo.isScrollEnabled = false
                }
                else{
                    self.Collectionview_Taxinfo.isScrollEnabled = true
                }
                
                if self.GuestCartList_Array.count == 0
                {
                    self.View_CouponCode.isHidden = true
                    self.view_total.isHidden = true
                }
                else
                {
                    self.View_CouponCode.isHidden = false
                    self.view_total.isHidden = false
                }
                self.Collectionview_Taxinfo.delegate = self
                self.Collectionview_Taxinfo.dataSource = self
                self.Collectionview_Taxinfo.reloadData()
                
                
                self.Tableview_CartList.delegate = self
                self.Tableview_CartList.dataSource = self
                self.Tableview_CartList.reloadData()
                self.Height_Tableview.constant = CGFloat(self.GuestCartList_Array.count * 95)
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
                self.lbl_couponcode.isHidden = true
                self.lbl_DiscountAmoint.isHidden = true
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    
}
