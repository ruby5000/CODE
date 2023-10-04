import UIKit
import SwiftyJSON

class cellTodayOrders : UITableViewCell {

  @IBOutlet weak var lbl_booking_number: UILabel!
  @IBOutlet weak var lbl_paymentType: UILabel!
  @IBOutlet weak var lbl_grand_total: UILabel!
  @IBOutlet weak var lbl_booking_date: UILabel!
  @IBOutlet weak var view_statusBG: UIView!
  @IBOutlet weak var lbl_status: UILabel!
}

class HomeVC: UIViewController {

  @IBOutlet weak var tableview_setting: UITableView!
  @IBOutlet weak var height_tableview: NSLayoutConstraint!
  @IBOutlet weak var emptyView: UIView!
  @IBOutlet weak var lbl_noDataFound: UILabel!
  @IBOutlet weak var lbl_earnings: UILabel!
  @IBOutlet weak var lbl_TotalOrders: UILabel!
  @IBOutlet weak var lbl_TodayOrders: UILabel!
  @IBOutlet weak var lbl_CancelOrders: UILabel!

  var arrOrdersData = [JSON]()

  override func viewDidLoad() {
    super.viewDidLoad()
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
      let urlString = "http://192.168.1.28/ecom-saas/api/home"
      let params: NSDictionary = ["vendor_id":"6"/*UserDefaultManager.getStringFromUserDefaults(key: UD_userId)*/]
      self.Webservice_TodayOrder(url: urlString, params: params)
    }
  }

}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {

  // MARK: - heightForRowAt
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }

  // MARK: - numberOfRowsInSection
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.arrOrdersData.count
  }

  // MARK: - cellForRowAt
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellTodayOrders") as! cellTodayOrders
    let data = arrOrdersData[indexPath.row]
    cell.lbl_booking_number.text = "#"+data["order_number"].stringValue
    cell.lbl_grand_total.text = UserDefaultManager.getStringFromUserDefaults(key: UD_currency)+data["grand_total"].stringValue
    cell.lbl_paymentType.text = data["transaction_type"].stringValue
    cell.lbl_booking_date.text = data["order_date"].stringValue

    if data["status"] == 1 {
      cell.lbl_status.text = "Pending"
      cell.view_statusBG.backgroundColor = UIColor(named: "Pending_Color")
    }
    else if data["status"] == 2 {
      cell.lbl_status.text = "Accepted"
      cell.view_statusBG.backgroundColor = UIColor(named: "Accepted_Color")
    }
    else if data["status"] == 3 {
      cell.lbl_status.text = "Rejected"
      cell.view_statusBG.backgroundColor = UIColor(named: "Rejected_Color")
    }
    else if data["status"] == 4 {
      cell.lbl_status.text = "Cancelled"
      cell.view_statusBG.backgroundColor = UIColor(named: "Cancelled_Color")
    }
    else if data["status"] == 5 {
      cell.lbl_status.text = "Completed"
      cell.view_statusBG.backgroundColor = UIColor(named: "Complete_Color")
    }
    return cell
  }

  // MARK: - didSelectRowAt
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = self.arrOrdersData[indexPath.item]
    let vc = self.storyboard?.instantiateViewController(identifier: "BookingHistoryDetailsVC") as! OrdersHistoryDetailsVC
    vc.booking_id = data["order_number"].stringValue
    self.navigationController?.pushViewController(vc, animated: true)
  }
}


extension HomeVC {

  // MARK: - TodayOrder api call
  func Webservice_TodayOrder(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      let status = jsonResponce!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponce!["data"].arrayValue

        if jsonResponce!["data"].arrayValue == [] {
          self.lbl_noDataFound.isHidden = false
        }
        UserDefaultManager.setStringToUserDefaults(value: jsonResponce!["currency"].stringValue, key: UD_currency)
        self.lbl_earnings.text = UserDefaultManager.getStringFromUserDefaults(key: UD_currency)+jsonResponce!["revenue"].stringValue
        self.lbl_TodayOrders.text = jsonResponce!["todayorders"].stringValue
        self.lbl_CancelOrders.text = jsonResponce!["cancelorders"].stringValue
        self.lbl_TotalOrders.text = jsonResponce!["totalorders"].stringValue
        self.arrOrdersData = jsondata
        self.tableview_setting.reloadData()
        self.tableview_setting.delegate = self
        self.tableview_setting.dataSource = self
        self.height_tableview.constant = CGFloat(self.arrOrdersData.count*120)
        self.emptyView.isHidden = true

        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}
