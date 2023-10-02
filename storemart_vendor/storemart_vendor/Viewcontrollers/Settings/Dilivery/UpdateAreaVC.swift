import UIKit

class UpdateAreaVC: UIViewController {

  @IBOutlet weak var txt_pice: UITextField!
  @IBOutlet weak var txt_Area: UITextField!

  var price = ""
  var area = ""
  var areaId = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    self.txt_pice.text = price
    self.txt_Area.text = area
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func btnTap_add(_ sender: UIButton) {
    let urlString = "https://store-mart.paponapps.co.in/api/editdeliveryarea"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "area_name":self.txt_Area.text!,
                                "price":self.txt_pice.text!,
                                "area_id":self.areaId]
    self.Webservice_updateDeliveryData(url: urlString, params: params)
  }

}

extension UpdateAreaVC {

  // MARK: - updateDeliveryData api calling
  func Webservice_updateDeliveryData(url:String, params:NSDictionary) -> Void {
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
