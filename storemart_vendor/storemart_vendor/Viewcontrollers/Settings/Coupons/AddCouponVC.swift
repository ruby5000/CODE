import UIKit

class AddCouponVC: UIViewController,UITextFieldDelegate {

  @IBOutlet weak var txt_name: UITextField!
  @IBOutlet weak var txt_code: UITextField!
  @IBOutlet weak var txt_price: UITextField!
  @IBOutlet weak var txt_activeFrom: UITextField!
  @IBOutlet weak var txt_activeTo: UITextField!
  @IBOutlet weak var txt_limitNumber: UITextField!


  override func viewDidLoad() {
    super.viewDidLoad()
    self.activeToDatePicker()
    self.activeFromDatePicker()
  }

  // txt_activeFrom
  func activeFromDatePicker() {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    txt_activeFrom.text = formatter.string(from: date)
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.frame.size = CGSize(width: 0, height: 100)
    datePicker.addTarget(self, action: #selector(datePickerValueChangedForFrom(sender:)), for: UIControl.Event.valueChanged)
    txt_activeFrom.inputView = datePicker
  }

  // txt_activeTo
  func activeToDatePicker() {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    txt_activeTo.text = formatter.string(from: date)
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.frame.size = CGSize(width: 0, height: 100)
    datePicker.addTarget(self, action: #selector(datePickerValueChangedForTo(sender:)), for: UIControl.Event.valueChanged)
    txt_activeTo.inputView = datePicker
  }

  // MARK: - datePickerValueChangedForFrom
  @objc func datePickerValueChangedForFrom(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    txt_activeFrom.text = formatter.string(from: sender.date)
  }

  // MARK: - datePickerValueChangedForTo
  @objc func datePickerValueChangedForTo(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    txt_activeTo.text = formatter.string(from: sender.date)
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func btnTap_add(_ sender: UIButton) {
    let urlString = "https://store-mart.paponapps.co.in/api/addcoupons"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "name":self.txt_name.text!,
                                "code":self.txt_code.text!,
                                "price":self.txt_price.text!,
                                "active_from":self.txt_activeFrom.text!,
                                "active_to":self.txt_activeTo.text!,
                                "limit":self.txt_limitNumber.text!]
    self.Webservice_addCouponsData(url: urlString, params: params)
  }
}

extension AddCouponVC {

  // MARK: - addCouponsData api calling
  func Webservice_addCouponsData(url:String, params:NSDictionary) -> Void {
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
