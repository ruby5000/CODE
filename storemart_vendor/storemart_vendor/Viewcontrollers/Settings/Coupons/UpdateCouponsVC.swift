import UIKit

class UpdateCouponsVC: UIViewController {

  @IBOutlet weak var txt_name: UITextField!
  @IBOutlet weak var txt_code: UITextField!
  @IBOutlet weak var txt_price: UITextField!
  @IBOutlet weak var txt_activeFrom: UITextField!
  @IBOutlet weak var txt_activeTo: UITextField!
  @IBOutlet weak var txt_limitNumber: UITextField!

  var name = ""
  var code = ""
  var price = ""
  var activeForm = ""
  var activeTo = ""
  var limitNumber = ""
  var couponId = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    self.txt_name.text = name
    self.txt_code.text = code
    self.txt_price.text = price
    self.txt_activeFrom.text = activeForm
    self.txt_activeTo.text = activeTo
    self.txt_limitNumber.text = limitNumber
    self.activeToDatePicker()
    self.activeFromDatePicker()
  }

  // txt_activeFrom
  func activeFromDatePicker() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.frame.size = CGSize(width: 0, height: 100)
    datePicker.addTarget(self, action: #selector(datePickerValueChangedForFrom(sender:)), for: UIControl.Event.valueChanged)
    txt_activeFrom.inputView = datePicker
  }

  // txt_activeTo
  func activeToDatePicker() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.frame.size = CGSize(width: 0, height: 100)
    datePicker.addTarget(self, action: #selector(datePickerValueChangedForTo(sender:)), for: UIControl.Event.valueChanged)
    txt_activeTo.inputView = datePicker
  }

  // txt_activeFrom
  @objc func datePickerValueChangedForFrom(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    txt_activeFrom.text = formatter.string(from: sender.date)
  }

  // txt_activeTo
  @objc func datePickerValueChangedForTo(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    txt_activeTo.text = formatter.string(from: sender.date)
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func btnTap_add(_ sender: UIButton) {
    let urlString = "https://store-mart.paponapps.co.in/api/editcoupons"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "name":self.txt_name.text!,
                                "code":self.txt_code.text!,
                                "price":self.txt_price.text!,
                                "active_from":self.txt_activeFrom.text!,
                                "active_to":self.txt_activeTo.text!,
                                "limit":self.txt_limitNumber.text!,
                                "coupon_id":self.couponId]
    self.Webservice_updateCouponsData(url: urlString, params: params)
  }

}


extension UpdateCouponsVC {

  // MARK: - updateCouponsData api calling
  func Webservice_updateCouponsData(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      let status = jsonResponce!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponce!["data"].arrayValue
        self.navigationController?.popViewController(animated: true)
        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}
