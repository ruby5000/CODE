import UIKit
import SwiftyJSON

class couponsCell: UITableViewCell{
  @IBOutlet weak var btn_delete: UIButton!
  @IBOutlet weak var btn_edit: UIButton!
  @IBOutlet weak var lbl_price: UILabel!
  @IBOutlet weak var lbl_code: UILabel!
}

class CouponsVC: UIViewController {

  @IBOutlet weak var tableview_coupons: UITableView!
  @IBOutlet weak var height_tableview_coupons: NSLayoutConstraint!

  var arrCouponsData = [JSON]()

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
      let urlString = "https://store-mart.paponapps.co.in/api/getcoupons"
      let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
      self.Webservice_getCoupons(url: urlString, params: params)
    }
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func btn_addCoupan(_ sender: UIButton) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCouponVC") as! AddCouponVC
    self.navigationController?.pushViewController(objVC, animated: true)
  }

}

extension CouponsVC : UITableViewDelegate, UITableViewDataSource {

  // MARK: - heightForrowAt
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }

  // MARK: - numberOfRowsInSection
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.arrCouponsData.count
  }

  // MARK: - cellForRowAt
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "couponsCell") as! couponsCell
    let data = self.arrCouponsData[indexPath.row]
    cell.lbl_code.text = data["code"].stringValue
    cell.lbl_price.text = data["price"].stringValue
    cell.btn_delete.tag = indexPath.row
    cell.btn_edit.tag = indexPath.row
    cell.btn_delete.addTarget(self, action: #selector(btnTap_delete), for: .touchUpInside)
    cell.btn_edit.addTarget(self, action: #selector(btnTap_edit), for: .touchUpInside)
    return cell
  }

  // MARK: - trailingSwipeActionsConfigurationForRowAt
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
      let data = self.arrCouponsData[indexPath.row]
      let urlString = "https://store-mart.paponapps.co.in/api/deletecoupons"
      let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                  "coupon_id":data["id"].stringValue]
      self.Webservice_DeleteCouponsData(url: urlString, params: params)
      complete(true)
    }

    // edit action
    let editAction = UIContextualAction(style: .destructive, title: "Edit") { _, _, complete in
      complete(true)
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCouponsVC") as! UpdateCouponsVC
      let data = self.arrCouponsData[indexPath.row]
      objVC.name = data["name"].stringValue
      objVC.code = data["code"].stringValue
      objVC.price = data["price"].stringValue
      objVC.activeForm = data["active_from"].stringValue
      objVC.activeTo = data["active_to"].stringValue
      objVC.limitNumber = data["limit"].stringValue
      objVC.couponId = data["id"].stringValue
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    deleteAction.backgroundColor = .red
    editAction.backgroundColor = .systemGreen

    let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    configuration.performsFirstActionWithFullSwipe = true
    return configuration
  }

  @objc func btnTap_delete(sender:UIButton) {
    let data = self.arrCouponsData[sender.tag]
    let urlString = "https://store-mart.paponapps.co.in/api/deletecoupons"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "coupon_id":data["id"].stringValue]
    self.Webservice_DeleteCouponsData(url: urlString, params: params)
  }

  @objc func btnTap_edit(sender:UIButton) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCouponsVC") as! UpdateCouponsVC
    let data = self.arrCouponsData[sender.tag]
    objVC.name = data["name"].stringValue
    objVC.code = data["code"].stringValue
    objVC.price = data["price"].stringValue
    objVC.activeForm = data["active_from"].stringValue
    objVC.activeTo = data["active_to"].stringValue
    objVC.limitNumber = data["limit"].stringValue
    objVC.couponId = data["id"].stringValue
    self.navigationController?.pushViewController(objVC, animated: true)
  }
}


extension CouponsVC {

  // MARK: - get Coupons api calling
  func Webservice_getCoupons(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      let status = jsonResponce!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponce!["data"].arrayValue
        self.arrCouponsData = jsondata
        self.tableview_coupons.reloadData()
        self.tableview_coupons.delegate = self
        self.tableview_coupons.dataSource = self
        self.height_tableview_coupons.constant = CGFloat(self.arrCouponsData.count*70)
        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
  
  // MARK: - DeleteCouponsData api calling
  func Webservice_DeleteCouponsData(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1" {

        let urlString = "https://store-mart.paponapps.co.in/api/getcoupons"
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
        self.Webservice_getCoupons(url: urlString, params: params)
        let jsondata = jsonResponse!["data"].arrayValue
        self.tableview_coupons.reloadData()
        showAlertMsg(Message: jsonResponse!["message"].stringValue, AutoHide: true)
        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}
