

import UIKit
import SwiftyJSON

class OrderhistoryDetailsVC: UIViewController {

  @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
  @IBOutlet weak var Tableview_OrderhistoryDetailsOrderList: UITableView!
  @IBOutlet weak var lbl_returnMsg: UILabel!
  @IBOutlet weak var lbl_orderid: UILabel!
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
  @IBOutlet weak var btn_TrackOrder: UIButton!
  @IBOutlet weak var btn_feedback: UIButton!
  @IBOutlet weak var lbl_line1: UILabel!
  @IBOutlet weak var view_Empty: UIView!

  var order_id = String()
  var product_Array = [JSON]()
  var Taxinfo_Array = [JSON]()
  var OrderStatus = String()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.btn_feedback.isHidden = false
    self.view_Empty.isHidden = false
    self.lbl_line1.isHidden = true
    self.Height_Totalview.constant = 0.0
    self.view_coupon.isHidden = true
    self.lbl_strcouponcode.isHidden = true
    self.lbl_CouponAmount.isHidden = true
    self.HeightView_Coupon.constant = 0.0
    let urlString = API_URL + "order-detail"
    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
    let params: NSDictionary = ["order_id":order_id,"theme_id":APP_THEME]
    self.Webservice_orderDetail(url: urlString, params: params, header: headers)

  }


}
//MARK: button action
extension OrderhistoryDetailsVC
{
  @IBAction func btnTap_TrackOrder(_ sender: UIButton) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
    vc.Status = OrderStatus
    self.navigationController?.pushViewController(vc, animated: true)
  }

  @IBAction func btnTap_Back(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }

  @IBAction func btnTap_Feedback(_ sender: UIButton) {
    if self.btn_feedback.titleLabel?.text == "Cancel Order"
    {
      let urlString = API_URL + "order-status-change"
      let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
      let params: NSDictionary = ["order_id":self.order_id,"order_status":"cancel","theme_id":APP_THEME]
      self.Webservice_StatusUpdate(url: urlString, params: params, header: headers)
    }
    else if self.btn_feedback.titleLabel?.text == "Return Order"
    {
      let urlString = API_URL + "order-status-change"
      let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
      let params: NSDictionary = ["order_id":self.order_id,"order_status":"return","theme_id":APP_THEME]
      self.Webservice_StatusUpdate(url: urlString, params: params, header: headers)
    }
  }
}
extension OrderhistoryDetailsVC : FeedbackDelegate
{
  func refreshData(id: String, rating_no: String, title: String, description: String) {
    let urlString = API_URL + "product-rating"
    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
    let params: NSDictionary = ["id":id,"user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"rating_no":rating_no,"title":title,"description":description,"theme_id":APP_THEME]
    self.Webservice_Productrating(url: urlString, params: params, header: headers)
  }
}
//MARK: Tableview Methods
extension OrderhistoryDetailsVC: UITableViewDelegate,UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.product_Array.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 95
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.Tableview_OrderhistoryDetailsOrderList.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell
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
    cell.btn_returnItem.tag = indexPath.row
    cell.btn_returnItem.addTarget(self, action: #selector(btnTapreturnItem), for: .touchUpInside)
    if data["return"].stringValue == "1"
    {
      cell.btn_returnItem.isHidden = true
    }
    else if data["return"].stringValue == "0"
    {
      cell.btn_returnItem.isHidden = false
    }
    return cell
  }

  @objc func btnTapreturnItem(sender:UIButton) {
    let data = self.product_Array[sender.tag]
    let urlString = API_URL + "product-return"
    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
    let params: NSDictionary = ["order_id":self.order_id,"product_id":data["product_id"].stringValue,"variant_id":data["variant_id"].stringValue,"theme_id":APP_THEME]
    self.Webservice_ProductReturan(url: urlString, params: params, header: headers)
  }

}
//MARK: CollectionView Deleget methods
extension OrderhistoryDetailsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.Taxinfo_Array.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = self.Collectionview_Taxinfo.dequeueReusableCell(withReuseIdentifier: "TaxinfoCell", for: indexPath) as! TaxinfoCell
    let data = self.Taxinfo_Array[indexPath.item]
    cell.lbl_title.text = data["tax_string"].stringValue
    let ItemPrice = formatter.string(for: data["amountstring"].stringValue.toDouble)
    cell.lbl_price.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    return CGSize(width: 100, height: 40)
  }

}
extension OrderhistoryDetailsVC
{
  func Webservice_orderDetail(url:String, params:NSDictionary,header:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1"
      {
        let jsondata = jsonResponse!["data"].dictionaryValue
        self.product_Array = jsondata["product"]!.arrayValue
        self.Taxinfo_Array = jsondata["tax"]!.arrayValue
        self.Tableview_OrderhistoryDetailsOrderList.delegate = self
        self.Tableview_OrderhistoryDetailsOrderList.dataSource = self
        self.Tableview_OrderhistoryDetailsOrderList.reloadData()
        self.Height_Tableview.constant = CGFloat(self.product_Array.count * 95)
        self.OrderStatus = jsondata["order_status"]!.stringValue
        if jsondata["order_status"]!.stringValue == "0"
        {
          self.btn_feedback.isHidden = false
          self.lbl_returnMsg.isHidden = true
          self.btn_feedback.setTitle("Cancel Order", for: .normal)
          self.btn_TrackOrder.isHidden = false
        }
        else if jsondata["order_status"]!.stringValue == "1"
        {
          self.btn_feedback.isHidden = false
          self.lbl_returnMsg.isHidden = true
          self.btn_feedback.setTitle("Return Order", for: .normal)
          self.btn_TrackOrder.isHidden = false
        }
        else if jsondata["order_status"]!.stringValue == "2"
        {
          self.btn_feedback.isHidden = true
          self.lbl_returnMsg.isHidden = false
          self.lbl_returnMsg.text = jsondata["order_status_message"]!.stringValue
          self.btn_TrackOrder.isHidden = true
        }
        else if jsondata["order_status"]!.stringValue == "3"
        {
          self.btn_feedback.isHidden = true
          self.lbl_returnMsg.isHidden = false
          self.lbl_returnMsg.text = jsondata["order_status_message"]!.stringValue
          self.btn_TrackOrder.isHidden = true
        }
        if self.Taxinfo_Array.count == 2
        {
          self.Collectionview_Taxinfo.isScrollEnabled = false
        }
        else
        {
          self.Collectionview_Taxinfo.isScrollEnabled = true
        }
        self.Collectionview_Taxinfo.delegate = self
        self.Collectionview_Taxinfo.dataSource = self
        self.Collectionview_Taxinfo.reloadData()
        self.img_payment.sd_setImage(with: URL(string: PAYMENT_URL + jsondata["paymnet"]!.stringValue), placeholderImage: UIImage(named: ""))
        self.img_delivery.sd_setImage(with: URL(string: IMG_URL + jsondata["delivery"]!.stringValue), placeholderImage: UIImage(named: ""))
        self.lbl_orderid.text = "Order\(jsondata["order_id"]!.stringValue)"
        let FinaltotalPrice = formatter.string(for: jsondata["final_price"]!.stringValue.toDouble)
        let SubtotalPrice = formatter.string(for: jsondata["sub_total"]!.stringValue.toDouble)
        self.lbl_subtotal.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(SubtotalPrice!)"
        self.lbl_finalTotal.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(FinaltotalPrice!)"
        let Coupon = jsondata["coupon_info"]!.dictionaryValue

        if Coupon.count != 0
        {
          //                    let CouponPrice = formatter.string(for: Coupon["price"]!.stringValue.toDouble)
          self.lbl_CouponAmount.text = "\(Coupon["discount_string"]!.stringValue) \n \(Coupon["discount_string2"]!.stringValue)"
          self.lbl_Couponcode.text = Coupon["code"]!.stringValue
          self.view_coupon.isHidden = false
          self.lbl_strcouponcode.isHidden = false
          self.lbl_CouponAmount.isHidden = false
          self.HeightView_Coupon.constant = 50.0
          self.Height_Totalview.constant = 250
          self.lbl_line1.isHidden = false
        }
        else{
          self.lbl_line1.isHidden = true
          self.view_coupon.isHidden = true
          self.lbl_strcouponcode.isHidden = true
          self.lbl_CouponAmount.isHidden = true
          self.HeightView_Coupon.constant = 0.0
          self.Height_Totalview.constant = 200
        }

        let billing_information = jsondata["billing_informations"]!.dictionaryValue
        self.lbl_billinginfo.text = "\(billing_information["name"]!.stringValue) \n \(billing_information["address"]!.stringValue), \(billing_information["post_code"]!.stringValue), \(billing_information["city"]!.stringValue), \(billing_information["state"]!.stringValue), \(billing_information["country"]!.stringValue), \n Phone:\(billing_information["phone"]!.stringValue) \n Email:\(billing_information["email"]!.stringValue)"
        let delivery_information = jsondata["delivery_informations"]!.dictionaryValue

        self.lbl_deliveryinfo.text = "\(delivery_information["name"]!.stringValue) \n \(delivery_information["address"]!.stringValue), \(delivery_information["post_code"]!.stringValue), \(delivery_information["city"]!.stringValue), \(delivery_information["state"]!.stringValue), \(delivery_information["country"]!.stringValue) \n Phone:\(delivery_information["phone"]!.stringValue) \n Email:\(delivery_information["email"]!.stringValue)"
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
  func Webservice_Productrating(url:String, params:NSDictionary,header:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1"
      {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
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
  func Webservice_StatusUpdate(url:String, params:NSDictionary,header:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1"
      {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
        let urlString = API_URL + "order-detail"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["order_id":self.order_id,"theme_id":APP_THEME]
        self.Webservice_orderDetail(url: urlString, params: params, header: headers)
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
  func Webservice_ProductReturan(url:String, params:NSDictionary,header:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1"
      {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
        let urlString = API_URL + "order-detail"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["order_id":self.order_id,"theme_id":APP_THEME]
        self.Webservice_orderDetail(url: urlString, params: params, header: headers)
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
