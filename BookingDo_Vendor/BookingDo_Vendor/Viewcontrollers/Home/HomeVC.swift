import UIKit
import SwiftyJSON

class cellTodayOrders : UITableViewCell {

  @IBOutlet weak var lbl_booking_number: UILabel!
  @IBOutlet weak var lbl_service_name: UILabel!
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
      let urlString = "http://192.168.1.28/bookingdo/api/home"
      let params: NSDictionary = ["vendor_id":"2"/*UserDefaultManager.getStringFromUserDefaults(key: UD_userId)*/]
      self.Webservice_TodayOrder(url: urlString, params: params)
    }
  }

}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.arrOrdersData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellTodayOrders") as! cellTodayOrders
    let data = arrOrdersData[indexPath.row]
    cell.lbl_booking_number.text = data["booking_number"].stringValue
    cell.lbl_grand_total.text = UserDefaultManager.getStringFromUserDefaults(key: UD_currency)+data["grand_total"].stringValue
    cell.lbl_service_name.text = data["service_name"].stringValue
    cell.lbl_booking_date.text = data["booking_date"].stringValue

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
    let vc = self.storyboard?.instantiateViewController(identifier: "BookingHistoryDetailsVC") as! BookingHistoryDetailsVC
    vc.booking_id = data["booking_number"].stringValue
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

        self.arrOrdersData = jsondata
        self.tableview_setting.reloadData()
        self.tableview_setting.delegate = self
        self.tableview_setting.dataSource = self
        self.height_tableview.constant = CGFloat(self.arrOrdersData.count*120)
        self.emptyView.isHidden = true
        UserDefaultManager.setStringToUserDefaults(value: jsonResponce!["currency"].stringValue, key: UD_currency)
        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}
