import UIKit
import SwiftyJSON

class cellOrderDetails: UITableViewCell {
  @IBOutlet weak var lbl_product_name: UILabel!
  @IBOutlet weak var lbl_variation_name: UILabel!
  @IBOutlet weak var lbl_qty: UILabel!
  @IBOutlet weak var lblproduct_price: UILabel!
  @IBOutlet weak var img_product: UIImageView!
}

class OrdersHistoryDetailsVC: UIViewController {

  // MARK: -
  @IBOutlet weak var lbl_booking_number: UILabel!
  @IBOutlet weak var lbl_customer_name: UILabel!
  @IBOutlet weak var lbl_address: UILabel!
  @IBOutlet weak var lbl_email: UILabel!
  @IBOutlet weak var lbl_mobile: UILabel!
  @IBOutlet weak var lbl_sub_total: UILabel!
  @IBOutlet weak var lbl_offer_amount: UILabel!
  @IBOutlet weak var lbl_tax: UILabel!
  @IBOutlet weak var lbl_grand_total: UILabel!
  @IBOutlet weak var txt_booking_notes: UITextView!
  @IBOutlet weak var lbl_status: UILabel!
  @IBOutlet weak var view_statusBG: UIView!
  @IBOutlet weak var btn_Accepted: UIButton!
  @IBOutlet weak var btn_Rejected: UIButton!
  @IBOutlet weak var btn_Cancel: UIButton!
  @IBOutlet weak var emptyView: UIView!
  @IBOutlet weak var tableview_ProductInfo: UITableView!
  @IBOutlet weak var height_ProductInfo: NSLayoutConstraint!
  @IBOutlet weak var lbl_customer_name_billing: UILabel!
  @IBOutlet weak var lbl_address_billing: UILabel!
  @IBOutlet weak var lbl_email_billing: UILabel!
  @IBOutlet weak var lbl_mobile_billing: UILabel!

  var booking_id = String()
  var status_temp = String()
  var arrProductDetails = [JSON]()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func btnTap_Back(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func btnTap_Cancel(_ sender: UIButton) {
    let urlString = "http://192.168.1.28/ecom-saas/api/statuschange"
    let params: NSDictionary = ["vendor_id":"6"/*UserDefaultManager.getStringFromUserDefaults(key: UD_userId)*/,
                                "order_number":self.booking_id,
                                "status":"4"]
    print(status_temp)
    print(booking_id)
    self.Webservice_StatusChangerd(url: urlString, params: params)
  }

  @IBAction func btnTap_Accepted(_ sender: UIButton) {
    let urlString = "http://192.168.1.28/ecom-saas/api/statuschange"
    let params: NSDictionary = ["vendor_id":"6"/*UserDefaultManager.getStringFromUserDefaults(key: UD_userId)*/,
                                "order_number":self.booking_id,
                                "status":"2"]
    print(status_temp)
    print(booking_id)
    self.Webservice_StatusChangerd(url: urlString, params: params)
  }

  @IBAction func btnTap_Rejected(_ sender: UIButton) {
    let urlString = "http://192.168.1.28/ecom-saas/api/statuschange"
    let params: NSDictionary = ["vendor_id":"6"/*UserDefaultManager.getStringFromUserDefaults(key: UD_userId)*/,
                                "order_number":self.booking_id,
                                "status":"3"]
    print(status_temp)
    print(booking_id)
    self.Webservice_StatusChangerd(url: urlString, params: params)
  }

  // MARK: - viewWillAppear
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "N/A" {
      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      let objVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
      let nav : UINavigationController = UINavigationController(rootViewController: objVC)
      nav.navigationBar.isHidden = true
      keyWindow?.rootViewController = nav
    } else {
      let urlString = "http://192.168.1.28/ecom-saas/api/orderdetail"
      let params: NSDictionary = ["vendor_id":"6"/*UserDefaultManager.getStringFromUserDefaults(key: UD_userId)*/,
                                  "order_number":booking_id]
      self.Webservice_BookingDetails(url: urlString, params: params)
    }
  }
}

extension OrdersHistoryDetailsVC : UITableViewDelegate, UITableViewDataSource {

  // MARK: - heightForRowAt
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 145
  }

  // MARK: - numberOfRowsInSection
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.arrProductDetails.count
  }

  // MARK: - cellForRowAt
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderDetails") as! cellOrderDetails
    let data = arrProductDetails[indexPath.row]
    cell.lbl_product_name.text = data["product_name"].stringValue
    cell.lbl_variation_name.text = data["variation_name"].stringValue
    cell.lbl_qty.text = data["qty"].stringValue
    cell.lblproduct_price.text = UserDefaultManager.getStringFromUserDefaults(key: UD_currency)+data["product_price"].stringValue
    cell.img_product.sd_setImage(with: URL(string:"\(data["product_image"].stringValue)"), placeholderImage: UIImage(named: "ic_placeholder"))
    return cell
  }
}


extension OrdersHistoryDetailsVC {

  // MARK: - BookingDetails api
  func Webservice_BookingDetails(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      let status = jsonResponce!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponce!["data"].dictionaryValue
        let productDetailsData = jsonResponce!["ordrdetail"].arrayValue
        self.arrProductDetails = productDetailsData

        self.lbl_customer_name.text = jsondata["user_name"]!.stringValue
        self.lbl_email.text = jsondata["user_email"]!.stringValue
        self.lbl_mobile.text = jsondata["user_mobile"]!.stringValue
        self.lbl_address.text = jsonResponce!["shippinginfo"]["shipping_address"].stringValue

        self.lbl_customer_name_billing.text = jsondata["user_name"]!.stringValue
        self.lbl_address_billing.text = jsonResponce!["biilinginfo"]["billing_address"].stringValue
        self.lbl_email_billing.text = jsondata["user_email"]!.stringValue
        self.lbl_mobile_billing.text = jsondata["user_mobile"]!.stringValue

        self.txt_booking_notes.text = jsondata["notes"]!.stringValue
        self.lbl_booking_number.text = jsondata["order_number"]!.stringValue

        self.lbl_sub_total.text = UserDefaultManager.getStringFromUserDefaults(key: UD_currency)+jsondata["sub_total"]!.stringValue
        self.lbl_offer_amount.text = UserDefaultManager.getStringFromUserDefaults(key: UD_currency)+jsondata["offer_amount"]!.stringValue
        self.lbl_tax.text = UserDefaultManager.getStringFromUserDefaults(key: UD_currency)+jsondata["tax_amount"]!.stringValue
        self.lbl_grand_total.text = UserDefaultManager.getStringFromUserDefaults(key: UD_currency)+jsondata["grand_total"]!.stringValue

        self.emptyView.isHidden = true
        self.tableview_ProductInfo.reloadData()
        self.tableview_ProductInfo.delegate = self
        self.tableview_ProductInfo.dataSource = self
        self.height_ProductInfo.constant = CGFloat(self.arrProductDetails.count*145)

        if jsondata["status"] == 1 {
          self.btn_Accepted.isHidden = false
          self.btn_Rejected.isHidden = false
          self.lbl_status.text = "Pending"
          self.view_statusBG.backgroundColor = UIColor(named: "Pending_Color")
        }
        else if jsondata["status"] == 2 {
          self.btn_Cancel.isHidden = false
          self.lbl_status.text = "Accepted"
          self.view_statusBG.backgroundColor = UIColor(named: "Accepted_Color")
        }
        else if jsondata["status"] == 3 {
          self.btn_Accepted.isHidden = true
          self.btn_Rejected.isHidden = true
          self.lbl_status.text = "Rejected"
          self.view_statusBG.backgroundColor = UIColor(named: "Rejected_Color")
        }
        else if jsondata["status"] == 4 {
          self.btn_Cancel.isHidden = true
          self.btn_Accepted.isHidden = true
          self.btn_Rejected.isHidden = true
          self.lbl_status.text = "Cancelled"
          self.view_statusBG.backgroundColor = UIColor(named: "Cancelled_Color")
        }
        else if jsondata["status"] == 5 {
          self.lbl_status.text = "Completed"
          self.view_statusBG.backgroundColor = UIColor(named: "Complete_Color")
        }
        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }

  // MARK: - StatusChanged api
  func Webservice_StatusChangerd(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      let status = jsonResponce!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponce!["data"].arrayValue

        let urlString = "http://192.168.1.28/ecom-saas/api/orderdetail"
        let params: NSDictionary = ["vendor_id":"6"/*UserDefaultManager.getStringFromUserDefaults(key: UD_userId)*/,
                                    "order_number":self.booking_id]
        self.Webservice_BookingDetails(url: urlString, params: params)

        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}
