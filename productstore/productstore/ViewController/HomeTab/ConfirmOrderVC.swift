//
//  ConfirmOrderVC.swift
//  Fashion
//
//  Created by Gravityinfotech on 25/03/22.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Stripe
class ConfirmOrderVC: UIViewController {
    
    
    @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
    @IBOutlet weak var Tableview_ConfirmproductsList: UITableView!
    
    
    @IBOutlet weak var lbl_deliveryinfo: UILabel!
    @IBOutlet weak var lbl_billinginfo: UILabel!
    
    @IBOutlet weak var img_payment: UIImageView!
    @IBOutlet weak var img_delivery: UIImageView!
    
    @IBOutlet weak var lbl_subtotal: UILabel!
    
    @IBOutlet weak var lbl_finalTotal: UILabel!
    @IBOutlet weak var lbl_Couponcode: UILabel!
    @IBOutlet weak var lbl_CouponAmount: UILabel!
    
    @IBOutlet weak var Collectionview_Taxinfo: UICollectionView!
    @IBOutlet weak var view_coupon: UIView!
    @IBOutlet weak var lbl_strcouponcode: UILabel!
    @IBOutlet weak var HeightView_Coupon: NSLayoutConstraint!
    @IBOutlet weak var Height_Totalview: NSLayoutConstraint!
    
    @IBOutlet weak var btn_Confirm: UIButton!
    @IBOutlet weak var lbl_line1: UILabel!
    @IBOutlet weak var view_Empty: UIView!
    //    var backendURL = URL(string: "https://apps.rajodiya.com/ecommerce/api/payment-sheet")!
    var paymentIntentClientSecret: String?
    var product_Array = [JSON]()
    var Taxinfo_Array = [JSON]()
    var GuestCartList_Array = [[String:String]]()
    var GuestTaxinfo_Array = [[String:String]]()
    
    var Final_Price = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_Confirm.isEnabled = false
        self.view_Empty.isHidden = false
        self.lbl_line1.isHidden = true
        self.Height_Totalview.constant = 0.0
        self.view_coupon.isHidden = true
        self.lbl_strcouponcode.isHidden = true
        self.lbl_CouponAmount.isHidden = true
        self.HeightView_Coupon.constant = 0.0
        
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            if UserDefaults.standard.value(forKey: UD_GuestObj) != nil
            {
                let Guest_Array = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestObj) as! [[String:String]]
                self.GuestCartList_Array = Guest_Array
                
                let Guest_Tax_Array = UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestTaxArray) as! [[String:String]]
                self.GuestTaxinfo_Array = Guest_Tax_Array
                
                let billing_information = UserDefaultManager.getCustomObjFromUserDefaults(key: UD_BillingObj) as! [String:String]
                
                self.lbl_billinginfo.text = "\(billing_information["firstname"]!) \(billing_information["lastname"]!) \n \(billing_information["billing_address"]!), \(billing_information["billing_postecode"]!), \(billing_information["billing_city"]!), \(UserDefaultManager.getStringFromUserDefaults(key: UD_SelectedState)), \(UserDefaultManager.getStringFromUserDefaults(key: UD_SelectedCountry)) \n Phone:\(billing_information["billing_user_telephone"]!) \n Email:\(billing_information["email"]!)"
                
                if billing_information["delivery_address"]! == ""
                {
                    self.lbl_deliveryinfo.text =  "-"
                }
                else
                {
                    self.lbl_deliveryinfo.text =  "\(billing_information["firstname"]!) \(billing_information["lastname"]!) \n \(billing_information["delivery_address"]!), \(billing_information["delivery_postcode"]!), \(billing_information["delivery_city"]!), \(UserDefaultManager.getStringFromUserDefaults(key: UD_SelectedState_Delivery)), \(UserDefaultManager.getStringFromUserDefaults(key: UD_SelectedCountry_Delivery)) \n Phone:\(billing_information["billing_user_telephone"]!) \n Email:\(billing_information["email"]!)"
                }
                let Guest_Coupon_Array = UserDefaultManager.getCustomObjFromUserDefaults(key: UD_CouponObj) as! [String:String]
                if Guest_Coupon_Array.count != 0
                {
                    self.lbl_CouponAmount.text = "-\(Guest_Coupon_Array["coupon_final_amount"]!) \(UserDefaultManager.getStringFromUserDefaults(key: UD_currency)) for all products (-\(Guest_Coupon_Array["coupon_final_amount"]!)\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name)))"
                    self.lbl_Couponcode.text = Guest_Coupon_Array["coupon_code"]!
                    self.view_coupon.isHidden = false
                    self.lbl_strcouponcode.isHidden = false
                    self.lbl_CouponAmount.isHidden = false
                    self.HeightView_Coupon.constant = 50.0
                    self.Height_Totalview.constant = 290
                    self.lbl_line1.isHidden = false
                }
                else
                {
                    self.lbl_line1.isHidden = true
                    self.view_coupon.isHidden = true
                    self.lbl_strcouponcode.isHidden = true
                    self.lbl_CouponAmount.isHidden = true
                    self.HeightView_Coupon.constant = 0.0
                    self.Height_Totalview.constant = 240
                }
                
                self.Tableview_ConfirmproductsList.delegate = self
                self.Tableview_ConfirmproductsList.dataSource = self
                self.Tableview_ConfirmproductsList.reloadData()
                self.Height_Tableview.constant = CGFloat(self.GuestCartList_Array.count * 100)
                
                if self.GuestTaxinfo_Array.count == 2
                {
                    self.Collectionview_Taxinfo.isScrollEnabled = false
                }
                else
                {
                    self.Collectionview_Taxinfo.isScrollEnabled = true
                }
                
                self.img_payment.sd_setImage(with: URL(string: PAYMENT_URL + UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentType_Image)), placeholderImage: UIImage(named: ""))
                self.img_delivery.sd_setImage(with: URL(string: IMG_URL + UserDefaultManager.getStringFromUserDefaults(key: UD_Delivery_Image)), placeholderImage: UIImage(named: ""))
                
                self.lbl_subtotal.text = UserDefaultManager.getStringFromUserDefaults(key: UD_GuestSubtotal)
                self.lbl_finalTotal.text = UserDefaultManager.getStringFromUserDefaults(key: UD_GuestFinaltotal)
                let total = UserDefaultManager.getStringFromUserDefaults(key: UD_GuestFinaltotal).replacingOccurrences(of:UserDefaultManager.getStringFromUserDefaults(key: UD_currency), with: "")
                print(total)
                self.Final_Price = "\(Int(Double(total.replacingOccurrences(of: ",", with: ""))! * 100))"
                self.Collectionview_Taxinfo.delegate = self
                self.Collectionview_Taxinfo.dataSource = self
                self.Collectionview_Taxinfo.reloadData()
                self.view_Empty.isHidden = true
                StripeAPI.defaultPublishableKey = UserDefaultManager.getStringFromUserDefaults(key: UD_Stripe_publishable_key)
                if UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentType) == "stripe"
                {
                    self.fetchPaymentIntent()
                }
                else{
                    self.btn_Confirm.isEnabled = true
                }
                
            }
        }
        else{
            let urlString = API_URL + "confirm-order"
            let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"coupon_info":UserDefaultManager.getCustomObjFromUserDefaults(key: UD_CouponObj),"billing_info":UserDefaultManager.getCustomObjFromUserDefaults(key: UD_BillingObj),"payment_type":UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentType),"payment_comment":UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentDescription),"delivery_id":UserDefaultManager.getStringFromUserDefaults(key: UD_Deliveryid),"delivery_comment":UserDefaultManager.getStringFromUserDefaults(key: UD_DeliveryDescription),"theme_id":APP_THEME]
            self.Webservice_OrderConfirm(url: urlString, params: params, header: headers)
        }
    }
    
}
//MARK: Button actions
extension ConfirmOrderVC
{
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_Confirm(_ sender: UIButton) {
        
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            if UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentType) == "stripe"
            {
                self.StripePay()
            }
            else{
                let urlString = API_URL + "place-order-guest"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["product":UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestProductArray),"tax_info":UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestTaxArray),"billing_info":UserDefaultManager.getCustomObjFromUserDefaults(key: UD_BillingObj),"coupon_info":UserDefaultManager.getCustomObjFromUserDefaults(key: UD_CouponObj),"payment_type":UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentType),"payment_comment":UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentDescription),"delivery_id":UserDefaultManager.getStringFromUserDefaults(key: UD_Deliveryid),"delivery_comment":UserDefaultManager.getStringFromUserDefaults(key: UD_DeliveryDescription),"theme_id":APP_THEME]
                print(params)
                self.Webservice_GuestPlaceOrder(url: urlString, params: params, header: headers)
            }
            
        }
        else{
            if UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentType) == "stripe"
            {
                self.StripePay()
            }
            else{
                let urlString = API_URL + "place-order"
                let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"coupon_info":UserDefaultManager.getCustomObjFromUserDefaults(key: UD_CouponObj),"billing_info":UserDefaultManager.getCustomObjFromUserDefaults(key: UD_BillingObj),"payment_type":UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentType),"payment_comment":UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentDescription),"delivery_id":UserDefaultManager.getStringFromUserDefaults(key: UD_Deliveryid),"delivery_comment":UserDefaultManager.getStringFromUserDefaults(key: UD_DeliveryDescription),"theme_id":APP_THEME]
                self.Webservice_OrderPlace(url: urlString, params: params, header: headers)
            }
        }
    }
}
extension ConfirmOrderVC
{
    func fetchPaymentIntent() {
        let url = URL(string: API_URL + "payment-sheet")!
        let shoppingCartContent: [String: Any] =
        [
            "price":"\(self.Final_Price)",
            "theme_id":APP_THEME,
            "currency":UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name)
        ]
        print(shoppingCartContent)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: shoppingCartContent)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let clientSecret = json["clientSecret"] as? String
                    
            else {
                let message = error?.localizedDescription ?? "Failed to decode response from server."
                showAlertMessage(titleStr: "Error loading page", messageStr: message)
                return
            }
            self?.paymentIntentClientSecret = clientSecret
            UserDefaultManager.setStringToUserDefaults(value: clientSecret, key: UD_clientSecret_key)
            DispatchQueue.main.async {
                self!.btn_Confirm.isEnabled = true
            }
        })
        task.resume()
    }
    func StripePay() {
        guard let paymentIntentClientSecret = self.paymentIntentClientSecret else {
            return
        }
        var configuration = PaymentSheet.Configuration()
        
        configuration.merchantDisplayName = "Stripe"
        let paymentSheet = PaymentSheet(
            paymentIntentClientSecret: paymentIntentClientSecret,
            configuration: configuration)
        paymentSheet.present(from: self) { [weak self] (paymentResult) in
            switch paymentResult {
            case .completed:
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_clientSecret_key)
                print(paymentResult)
                if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
                {
                    let urlString = API_URL + "place-order-guest"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["product":UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestProductArray),"tax_info":UserDefaultManager.getCustomObjFromUserDefaultsGuest(key: UD_GuestTaxArray),"billing_info":UserDefaultManager.getCustomObjFromUserDefaults(key: UD_BillingObj),"coupon_info":UserDefaultManager.getCustomObjFromUserDefaults(key: UD_CouponObj),"payment_type":UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentType),"payment_comment":UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentDescription),"delivery_id":UserDefaultManager.getStringFromUserDefaults(key: UD_Deliveryid),"delivery_comment":UserDefaultManager.getStringFromUserDefaults(key: UD_DeliveryDescription),"theme_id":APP_THEME]
                    print(params)
                    self!.Webservice_GuestPlaceOrder(url: urlString, params: params, header: headers)
                }
                else
                {
                    let urlString = API_URL + "place-order"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"coupon_info":UserDefaultManager.getCustomObjFromUserDefaults(key: UD_CouponObj),"billing_info":UserDefaultManager.getCustomObjFromUserDefaults(key: UD_BillingObj),"payment_type":UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentType),"payment_comment":UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentDescription),"delivery_id":UserDefaultManager.getStringFromUserDefaults(key: UD_Deliveryid),"delivery_comment":UserDefaultManager.getStringFromUserDefaults(key: UD_DeliveryDescription),"theme_id":APP_THEME]
                    self!.Webservice_OrderPlace(url: urlString, params: params, header: headers)
                }
                
            case .canceled:
                print("Payment canceled!")
            case .failed(let error):
                showAlertMessage(titleStr: "Payment failed", messageStr: error.localizedDescription)
            }
        }
    }
}

//MARK: Tableview Methods
extension ConfirmOrderVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            return self.GuestCartList_Array.count
        }
        else{
            return product_Array.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let cell = self.Tableview_ConfirmproductsList.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell
            let data = GuestCartList_Array[indexPath.row]
            let ItemPrice = formatter.string(for: data["final_price"]!.toDouble)
            let TotalItemPrice = Double(ItemPrice!.replacingOccurrences(of: ",", with: ""))! * Double("\(data["qty"]!)")!
            let ItemPricetotal = formatter.string(for: "\(TotalItemPrice)".toDouble)
            cell.lbl_price.text = "\(ItemPricetotal!) \(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))"
            let original3 = IMG_URL + data["image"]!
            if let encoded = original3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let url = URL(string: encoded)
            {
                cell.img_products.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            }
            cell.lbl_name.text = data["name"]!
            cell.lbl_size.text = data["variant_name"]!
            cell.lbl_qty.text = "Qty: \(data["qty"]!)"
            return cell
        }
        else
        {
            let cell = self.Tableview_ConfirmproductsList.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell
            let data = product_Array[indexPath.row]
            let ItemPrice = formatter.string(for: data["final_price"].stringValue.toDouble)
            cell.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
            
            let original3 = IMG_URL + data["image"].stringValue
            if let encoded = original3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let url = URL(string: encoded)
            {
                cell.img_products.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            }
            cell.lbl_name.text = data["name"].stringValue
            cell.lbl_size.text = data["variant_name"].stringValue
            cell.lbl_qty.text = "Qty: \(data["qty"].stringValue)"
            return cell
        }
    }
}
// MARK:- CollectionView Deleget methods
extension ConfirmOrderVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            return self.GuestTaxinfo_Array.count
        }
        else{
            return self.Taxinfo_Array.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let cell = self.Collectionview_Taxinfo.dequeueReusableCell(withReuseIdentifier: "TaxinfoCell", for: indexPath) as! TaxinfoCell
            let data = self.GuestTaxinfo_Array[indexPath.item]
            cell.lbl_title.text = data["tax_string"]!
            let ItemPrice = formatter.string(for: data["tax_price"]!.toDouble)
            cell.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
            return cell
        }
        else{
            let cell = self.Collectionview_Taxinfo.dequeueReusableCell(withReuseIdentifier: "TaxinfoCell", for: indexPath) as! TaxinfoCell
            let data = self.Taxinfo_Array[indexPath.item]
            cell.lbl_title.text = data["tax_string"].stringValue
            let ItemPrice = formatter.string(for: data["tax_price"].stringValue.toDouble)
            cell.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100, height: 40)
    }
    
}
extension ConfirmOrderVC
{
    func Webservice_OrderConfirm(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                self.product_Array = jsondata["product"]!.arrayValue
                self.Taxinfo_Array = jsondata["tax"]!.arrayValue
                
                self.Tableview_ConfirmproductsList.delegate = self
                self.Tableview_ConfirmproductsList.dataSource = self
                self.Tableview_ConfirmproductsList.reloadData()
                self.Height_Tableview.constant = CGFloat(self.product_Array.count * 100)
                
                if self.Taxinfo_Array.count == 2
                {
                    self.Collectionview_Taxinfo.isScrollEnabled = false
                }
                else{
                    self.Collectionview_Taxinfo.isScrollEnabled = true
                }
                self.Collectionview_Taxinfo.delegate = self
                self.Collectionview_Taxinfo.dataSource = self
                self.Collectionview_Taxinfo.reloadData()
                
                self.img_payment.sd_setImage(with: URL(string: PAYMENT_URL + jsondata["paymnet"]!.stringValue), placeholderImage: UIImage(named: ""))
                self.img_delivery.sd_setImage(with: URL(string: IMG_URL + jsondata["delivery"]!.stringValue), placeholderImage: UIImage(named: ""))
                let FinaltotalPrice = formatter.string(for: jsondata["final_price"]!.stringValue.toDouble)
                self.Final_Price = "\(Int(Double(FinaltotalPrice!.replacingOccurrences(of: ",", with: ""))! * 100))"
                let SubtotalPrice = formatter.string(for: jsondata["subtotal"]!.stringValue.toDouble)
                self.lbl_subtotal.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(SubtotalPrice!)"
                self.lbl_finalTotal.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(FinaltotalPrice!)"
                let Coupon = jsondata["coupon_info"]!.dictionaryValue
                if Coupon.count != 0
                {
                    //let CouponPrice = formatter.string(for: Coupon["price"]!.stringValue.toDouble)
                    self.lbl_CouponAmount.text = "\(Coupon["discount_string"]!.stringValue) \n \(Coupon["discount_string2"]!.stringValue)"
                    self.lbl_Couponcode.text = Coupon["code"]!.stringValue
                    self.lbl_line1.isHidden = false
                    self.view_coupon.isHidden = false
                    self.lbl_strcouponcode.isHidden = false
                    self.lbl_CouponAmount.isHidden = false
                    self.HeightView_Coupon.constant = 50.0
                    self.Height_Totalview.constant = 290
                }
                else
                {
                    self.lbl_line1.isHidden = true
                    self.view_coupon.isHidden = true
                    self.lbl_strcouponcode.isHidden = true
                    self.lbl_CouponAmount.isHidden = true
                    self.HeightView_Coupon.constant = 0.0
                    self.Height_Totalview.constant = 240
                }
                
                let billing_information = jsondata["billing_information"]!.dictionaryValue
                self.lbl_billinginfo.text = "\(billing_information["name"]!.stringValue) \n \(billing_information["address"]!.stringValue), \(billing_information["city"]!.stringValue), \(billing_information["state"]!.stringValue), \(billing_information["country"]!.stringValue) - \(billing_information["postecode"]!.stringValue) \n Phone:\(billing_information["phone"]!.stringValue) \n Email:\(billing_information["email"]!.stringValue)"
                
                let delivery_information = jsondata["delivery_information"]!.dictionaryValue
                if delivery_information["address"]!.stringValue == ""
                {
                    self.lbl_deliveryinfo.text =  "-"
                }
                else
                {
                    self.lbl_deliveryinfo.text = "\(delivery_information["name"]!.stringValue) \n \(delivery_information["address"]!.stringValue), \(delivery_information["city"]!.stringValue), \(delivery_information["state"]!.stringValue), \(delivery_information["country"]!.stringValue) - \(delivery_information["postecode"]!.stringValue) \n Phone:\(delivery_information["phone"]!.stringValue) \n Email:\(delivery_information["email"]!.stringValue)"
                }
                self.view_Empty.isHidden = true
                StripeAPI.defaultPublishableKey = UserDefaultManager.getStringFromUserDefaults(key: UD_Stripe_publishable_key)
                if UserDefaultManager.getStringFromUserDefaults(key: UD_PaymentType) == "stripe"
                {
                    self.fetchPaymentIntent()
                }
                else{
                    self.btn_Confirm.isEnabled = true
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
    func Webservice_OrderPlace(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                let complete_order = jsondata["complete_order"]!.dictionaryValue
                let order_complate = complete_order["order-complate"]!.dictionaryValue
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderPlaceSucessVC") as! OrderPlaceSucessVC
                vc.desc = order_complate["order-complate-description"]!.stringValue
                vc.toptitle = order_complate["order-complate-title"]!.stringValue
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
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
    func Webservice_GuestPlaceOrder(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                let complete_order = jsondata["complete_order"]!.dictionaryValue
                let order_complate = complete_order["order-complate"]!.dictionaryValue
                
                UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestObj)
                
                UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestProductArray)
                UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestTaxArray)
                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_GuestTaxArray)
                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_CouponObj)
                UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_BillingObj)
                
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_PaymentType)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_PaymentDescription)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_Deliveryid)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_DeliveryDescription)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_CartCount)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderPlaceSucessVC") as! OrderPlaceSucessVC
                vc.desc = order_complate["order-complate-description"]!.stringValue
                vc.toptitle = order_complate["order-complate-title"]!.stringValue
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
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
}
extension String {
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
}
