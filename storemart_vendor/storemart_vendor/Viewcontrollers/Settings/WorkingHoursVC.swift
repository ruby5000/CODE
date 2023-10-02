import UIKit
import SwiftyJSON

class WorkingHoursVC: UIViewController {

  @IBOutlet weak var lbl_Monday: UILabel!
  @IBOutlet weak var lbl_Tuesday: UILabel!
  @IBOutlet weak var lbl_Wednesday: UILabel!
  @IBOutlet weak var lbl_Thursday: UILabel!
  @IBOutlet weak var lbl_Friday: UILabel!
  @IBOutlet weak var lbl_Saturday: UILabel!
  @IBOutlet weak var lbl_Sunday: UILabel!

  @IBOutlet weak var txt_Monday_openTime: UITextField!
  @IBOutlet weak var txt_Tuesday_openTime: UITextField!
  @IBOutlet weak var txt_Wednesday_openTime: UITextField!
  @IBOutlet weak var txt_Thursday_openTime: UITextField!
  @IBOutlet weak var txt_Friday_openTime: UITextField!
  @IBOutlet weak var txt_Saturday_openTime: UITextField!
  @IBOutlet weak var txt_Sunday_openTime: UITextField!

  @IBOutlet weak var txt_Monday_CloseTime: UITextField!
  @IBOutlet weak var txt_Tuesday_CloseTime: UITextField!
  @IBOutlet weak var txt_Wednesday_CloseTime: UITextField!
  @IBOutlet weak var txt_Thursday_CloseTime: UITextField!
  @IBOutlet weak var txt_Friday_CloseTime: UITextField!
  @IBOutlet weak var txt_Saturday_CloseTime: UITextField!
  @IBOutlet weak var txt_Sunday_CloseTime: UITextField!

  @IBOutlet weak var switch_Monday: UISwitch!
  @IBOutlet weak var switch_Tuesday: UISwitch!
  @IBOutlet weak var switch_Wednesday: UISwitch!
  @IBOutlet weak var switch_Thursday: UISwitch!
  @IBOutlet weak var switch_Friday: UISwitch!
  @IBOutlet weak var switch_saturdar: UISwitch!
  @IBOutlet weak var switch_Sunday: UISwitch!

  @IBOutlet weak var view_empty: UIView!

  var arrHoursData = [JSON]()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view_empty.isHidden = false

    self.Monday_Open_Time()
    self.TuesDay_Open_Time()
    self.Wednesday_Open_Time()
    self.Thursday_Open_Time()
    self.Friday_Open_Time()
    self.Saturday_Open_Time()
    self.Sunday_Open_Time()

    self.Monday_Close_Time()
    self.Tuesday_Close_Time()
    self.Wednesday_Close_Time()
    self.Thursday_Close_Time()
    self.Friday_Close_Time()
    self.Saturday_Close_Time()
    self.Sunday_Close_Time()
  }

  @IBAction func Switch_Monday(_ sender: UISwitch) {
    if switch_Monday.isOn == true {
      UserDefaultManager.setStringToUserDefaults(value: "2", key: UD_SWITCHON)
    } else {
      UserDefaultManager.setStringToUserDefaults(value: "1", key: UD_SWITCHON)
    }
  }

  @IBAction func Switch_Tuesday(_ sender: UISwitch) {
    if switch_Tuesday.isOn == true {
      UserDefaultManager.setStringToUserDefaults(value: "2", key: UD_SWITCHON)
    } else {
      UserDefaultManager.setStringToUserDefaults(value: "1", key: UD_SWITCHON)
    }
  }

  @IBAction func Switch_Wednesday(_ sender: UISwitch) {
    if switch_Wednesday.isOn == true {
      UserDefaultManager.setStringToUserDefaults(value: "2", key: UD_SWITCHON)
    } else {
      UserDefaultManager.setStringToUserDefaults(value: "1", key: UD_SWITCHON)
    }
  }

  @IBAction func Switch_Thrusday(_ sender: UISwitch) {
    if switch_Thursday.isOn == true {
      UserDefaultManager.setStringToUserDefaults(value: "2", key: UD_SWITCHON)
    } else {
      UserDefaultManager.setStringToUserDefaults(value: "1", key: UD_SWITCHON)
    }
  }

  @IBAction func Switch_Friday(_ sender: UISwitch) {
    if switch_Friday.isOn == true {
      UserDefaultManager.setStringToUserDefaults(value: "2", key: UD_SWITCHON)
    } else {
      UserDefaultManager.setStringToUserDefaults(value: "1", key: UD_SWITCHON)
    }
  }

  @IBAction func Switch_Saturday(_ sender: UISwitch) {
    if switch_saturdar.isOn == true {
      UserDefaultManager.setStringToUserDefaults(value: "2", key: UD_SWITCHON)
    } else {
      UserDefaultManager.setStringToUserDefaults(value: "1", key: UD_SWITCHON)
    }
  }

  @IBAction func Switch_Sunday(_ sender: UISwitch) {
    if switch_Sunday.isOn == true {
      UserDefaultManager.setStringToUserDefaults(value: "2", key: UD_SWITCHON)
    } else {
      UserDefaultManager.setStringToUserDefaults(value: "1", key: UD_SWITCHON)
    }
  }


  @IBAction func btnTap_monday(_ sender: UIButton) {
    let urlString = "https://store-mart.paponapps.co.in/api/edithours"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "day":"Monday",
                                "open_time":self.txt_Monday_openTime.text!,
                                "close_time":self.txt_Monday_CloseTime.text!,
                                "is_always_close":UserDefaultManager.getStringFromUserDefaults(key: UD_SWITCHON)]
    self.Webservice_UpdateHoursData(url: urlString, params: params)
  }

  @IBAction func btnTap_tuesday(_ sender: UIButton) {
    let urlString = "https://store-mart.paponapps.co.in/api/edithours"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "day":"Tuesday",
                                "open_time":self.txt_Tuesday_openTime.text!,
                                "close_time":self.txt_Tuesday_CloseTime.text!,
                                "is_always_close":UserDefaultManager.getStringFromUserDefaults(key: UD_SWITCHON)]
    self.Webservice_UpdateHoursData(url: urlString, params: params)
  }

  @IBAction func btnTap_wednesday(_ sender: UIButton) {
    let urlString = "https://store-mart.paponapps.co.in/api/edithours"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "day":"Wednesday",
                                "open_time":self.txt_Wednesday_openTime.text!,
                                "close_time":self.txt_Wednesday_CloseTime.text!,
                                "is_always_close":UserDefaultManager.getStringFromUserDefaults(key: UD_SWITCHON)]
    self.Webservice_UpdateHoursData(url: urlString, params: params)
  }

  @IBAction func btnTap_thursday(_ sender: UIButton) {
    let urlString = "https://store-mart.paponapps.co.in/api/edithours"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "day":"Thursday",
                                "open_time":self.txt_Thursday_openTime.text!,
                                "close_time":self.txt_Thursday_CloseTime.text!,
                                "is_always_close":UserDefaultManager.getStringFromUserDefaults(key: UD_SWITCHON)]
    self.Webservice_UpdateHoursData(url: urlString, params: params)
  }

  @IBAction func btnTap_friday(_ sender: UIButton) {
    let urlString = "https://store-mart.paponapps.co.in/api/edithours"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "day":"Friday",
                                "open_time":self.txt_Friday_openTime.text!,
                                "close_time":self.txt_Friday_CloseTime.text!,
                                "is_always_close":UserDefaultManager.getStringFromUserDefaults(key: UD_SWITCHON)]
    self.Webservice_UpdateHoursData(url: urlString, params: params)
  }

  @IBAction func btnTap_saturday(_ sender: UIButton) {
    let urlString = "https://store-mart.paponapps.co.in/api/edithours"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "day":"Saturday",
                                "open_time":self.txt_Saturday_openTime.text!,
                                "close_time":self.txt_Saturday_CloseTime.text!,
                                "is_always_close":UserDefaultManager.getStringFromUserDefaults(key: UD_SWITCHON)]
    self.Webservice_UpdateHoursData(url: urlString, params: params)
  }

  @IBAction func btnTap_Sunday(_ sender: UIButton) {
    let urlString = "https://store-mart.paponapps.co.in/api/edithours"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "day":"Sunday",
                                "open_time":self.txt_Sunday_openTime.text!,
                                "close_time":self.txt_Sunday_CloseTime.text!,
                                "is_always_close":UserDefaultManager.getStringFromUserDefaults(key: UD_SWITCHON)]
    self.Webservice_UpdateHoursData(url: urlString, params: params)
  }


  // -----------------------------------------------------------------------Monday----------------------------------------------------------------------------------

  func Monday_Open_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(monday_open_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Monday_openTime.inputView = timePicker
  }
  @objc func monday_open_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Monday_openTime.text = formatter.string(from: sender.date)
  }

  func Monday_Close_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(monday_close_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Monday_CloseTime.inputView = timePicker
  }
  @objc func monday_close_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Monday_CloseTime.text = formatter.string(from: sender.date)
  }

  // -----------------------------------------------------------------------TuesDay----------------------------------------------------------------------------------

  func TuesDay_Open_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(tuesday_open_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Tuesday_openTime.inputView = timePicker
  }
  @objc func tuesday_open_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Tuesday_openTime.text = formatter.string(from: sender.date)
  }

  func Tuesday_Close_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(Tuesday_close_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Tuesday_CloseTime.inputView = timePicker
  }
  @objc func Tuesday_close_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Tuesday_CloseTime.text = formatter.string(from: sender.date)
  }

  // -----------------------------------------------------------------------Wednesday----------------------------------------------------------------------------------

  func Wednesday_Open_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(wednesday_open_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Wednesday_openTime.inputView = timePicker
  }
  @objc func wednesday_open_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Wednesday_openTime.text = formatter.string(from: sender.date)
  }

  func Wednesday_Close_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(Wednesday_close_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Wednesday_CloseTime.inputView = timePicker
  }
  @objc func Wednesday_close_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Wednesday_CloseTime.text = formatter.string(from: sender.date)
  }

  // -----------------------------------------------------------------------Thursday----------------------------------------------------------------------------------

  func Thursday_Open_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(Thursday_open_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Thursday_openTime.inputView = timePicker
  }
  @objc func Thursday_open_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Thursday_openTime.text = formatter.string(from: sender.date)
  }

  func Thursday_Close_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(Thursday_close_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Thursday_CloseTime.inputView = timePicker
  }
  @objc func Thursday_close_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Thursday_CloseTime.text = formatter.string(from: sender.date)
  }
  // -----------------------------------------------------------------------Friday----------------------------------------------------------------------------------

  func Friday_Open_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(Friday_open_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Friday_openTime.inputView = timePicker
  }
  @objc func Friday_open_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Friday_openTime.text = formatter.string(from: sender.date)
  }

  func Friday_Close_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(Friday_close_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Friday_CloseTime.inputView = timePicker
  }
  @objc func Friday_close_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Friday_CloseTime.text = formatter.string(from: sender.date)
  }

  // -----------------------------------------------------------------------Saturday----------------------------------------------------------------------------------

  func Saturday_Open_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(Saturday_open_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Saturday_openTime.inputView = timePicker
  }
  @objc func Saturday_open_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Saturday_openTime.text = formatter.string(from: sender.date)
  }

  func Saturday_Close_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(Saturday_close_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Saturday_CloseTime.inputView = timePicker
  }
  @objc func Saturday_close_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Saturday_CloseTime.text = formatter.string(from: sender.date)
  }
  // -----------------------------------------------------------------------Sunday----------------------------------------------------------------------------------

  func Sunday_Open_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(Sunday_open_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Sunday_openTime.inputView = timePicker
  }
  @objc func Sunday_open_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Sunday_openTime.text = formatter.string(from: sender.date)
  }

  func Sunday_Close_Time() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"

    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.addTarget(self, action: #selector(Sunday_close_time(sender:)), for: UIControl.Event.valueChanged)
    timePicker.frame.size = CGSize(width: 0, height: 100)
    self.txt_Sunday_CloseTime.inputView = timePicker
  }
  @objc func Sunday_close_time(sender: UIDatePicker){
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_gb")
    formatter.dateFormat = "hh:mm a"
    self.txt_Sunday_CloseTime.text = formatter.string(from: sender.date)
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
      let urlString = "https://store-mart.paponapps.co.in/api/gethours"
      let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
      self.Webservice_getHoursData(url: urlString, params: params)
    }
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

}


extension WorkingHoursVC {
  func Webservice_getHoursData(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      let status = jsonResponce!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponce!["data"].arrayValue
        self.arrHoursData = jsondata
        self.lbl_Monday.text = jsondata[0]["day"].stringValue
        self.lbl_Tuesday.text = jsondata[1]["day"].stringValue
        self.lbl_Wednesday.text = jsondata[2]["day"].stringValue
        self.lbl_Thursday.text = jsondata[3]["day"].stringValue
        self.lbl_Friday.text = jsondata[4]["day"].stringValue
        self.lbl_Saturday.text = jsondata[5]["day"].stringValue
        self.lbl_Sunday.text = jsondata[6]["day"].stringValue

        self.txt_Monday_openTime.text = jsondata[0]["open_time"].stringValue
        self.txt_Tuesday_openTime.text = jsondata[1]["open_time"].stringValue
        self.txt_Wednesday_openTime.text = jsondata[2]["open_time"].stringValue
        self.txt_Thursday_openTime.text = jsondata[3]["open_time"].stringValue
        self.txt_Friday_openTime.text = jsondata[4]["open_time"].stringValue
        self.txt_Saturday_openTime.text = jsondata[5]["open_time"].stringValue
        self.txt_Sunday_openTime.text = jsondata[6]["open_time"].stringValue

        self.txt_Monday_CloseTime.text = jsondata[0]["close_time"].stringValue
        self.txt_Tuesday_CloseTime.text = jsondata[1]["close_time"].stringValue
        self.txt_Wednesday_CloseTime.text = jsondata[2]["close_time"].stringValue
        self.txt_Thursday_CloseTime.text = jsondata[3]["close_time"].stringValue
        self.txt_Friday_CloseTime.text = jsondata[4]["close_time"].stringValue
        self.txt_Saturday_CloseTime.text = jsondata[5]["close_time"].stringValue
        self.txt_Sunday_CloseTime.text = jsondata[6]["close_time"].stringValue

        self.view_empty.isHidden = true

        if jsondata[0]["is_always_close"] == "2" {
          self.switch_Monday.isOn = true
        } else {
          self.switch_Monday.isOn = false
        }

        if jsondata[1]["is_always_close"] == "2" {
          self.switch_Tuesday.isOn = true
        } else {
          self.switch_Tuesday.isOn = false
        }

        if jsondata[2]["is_always_close"] == "2" {
          self.switch_Wednesday.isOn = true
        } else {
          self.switch_Wednesday.isOn = false
        }

        if jsondata[3]["is_always_close"] == "2" {
          self.switch_Thursday.isOn = true
        } else {
          self.switch_Thursday.isOn = false
        }

        if jsondata[4]["is_always_close"] == "2" {
          self.switch_Friday.isOn = true
        } else {
          self.switch_Friday.isOn = false
        }

        if jsondata[5]["is_always_close"] == "2" {
          self.switch_saturdar.isOn = true
        } else {
          self.switch_saturdar.isOn = false
        }

        if jsondata[6]["is_always_close"] == "2" {
          self.switch_Sunday.isOn = true
        } else {
          self.switch_Sunday.isOn = false
        }


        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }

  // MARK: - UpdateHoursData
  func Webservice_UpdateHoursData(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1" {

        let urlString = "https://store-mart.paponapps.co.in/api/gethours"
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
        self.Webservice_getHoursData(url: urlString, params: params)
        let jsondata = jsonResponse!["data"].arrayValue
        showAlertMsg(Message: jsonResponse!["message"].stringValue, AutoHide: true)
        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}
