import UIKit
import SwiftyJSON
import Alamofire

class deliveryAreaCell: UITableViewCell{
  @IBOutlet weak var lbl_price: UILabel!
  @IBOutlet weak var lbl_Area: UILabel!
  @IBOutlet weak var btn_delete: UIButton!
  @IBOutlet weak var btn_edit: UIButton!
}

class DeliveryAreaVC: UIViewController {

  @IBOutlet weak var tableview_deliveryArea: UITableView!
  @IBOutlet weak var height_tableview_deliveryArea: NSLayoutConstraint!

  var arrDeliveryArea = [JSON]()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "N/A" {
      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      let objVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
      let nav : UINavigationController = UINavigationController(rootViewController: objVC)
      nav.navigationBar.isHidden = true
      keyWindow?.rootViewController = nav
    } else {
      let urlString = "https://store-mart.paponapps.co.in/api/getdeliveryarea"
      let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
      self.Webservice_getdeliveryarea(url: urlString, params: params)
    }
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func btn_addArea(_ sender: UIButton) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAreaVC") as! AddAreaVC
    self.navigationController?.pushViewController(objVC, animated: true)
  }
}


extension DeliveryAreaVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.arrDeliveryArea.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAreaCell") as! deliveryAreaCell
    let data = self.arrDeliveryArea[indexPath.row]
    cell.lbl_Area.text = data["name"].stringValue
    cell.lbl_price.text = data["price"].stringValue
    cell.btn_delete.tag = indexPath.row
    cell.btn_edit.tag = indexPath.row
    cell.btn_delete.addTarget(self, action: #selector(btnTap_delete), for: .touchUpInside)
    cell.btn_edit.addTarget(self, action: #selector(btnTap_edit), for: .touchUpInside)
    return cell
  }

  // MARK: - canEditRowAt
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
      let data = self.arrDeliveryArea[indexPath.row]
      let urlString = "https://store-mart.paponapps.co.in/api/deletedeliveryarea"
      let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                  "area_id":data["id"].rawValue]
      self.Webservice_DeleteDeliveryData(url: urlString, params: params)
      complete(true)
    }

    let editAction = UIContextualAction(style: .destructive, title: "Edit") { _, _, complete in
      complete(true)
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAreaVC") as! UpdateAreaVC
      let data = self.arrDeliveryArea[indexPath.row]
      objVC.area = data["name"].stringValue
      objVC.price = data["price"].stringValue
      objVC.areaId = data["id"].stringValue
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    deleteAction.backgroundColor = .red
    editAction.backgroundColor = .systemGreen

    let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    configuration.performsFirstActionWithFullSwipe = true
    return configuration
  }

  @objc func btnTap_delete(sender:UIButton) {
    let data = self.arrDeliveryArea[sender.tag]
    let urlString = "https://store-mart.paponapps.co.in/api/deletedeliveryarea"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "area_id":data["id"].stringValue]
    self.Webservice_DeleteDeliveryData(url: urlString, params: params)
  }

  @objc func btnTap_edit(sender:UIButton) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAreaVC") as! UpdateAreaVC
    let data = self.arrDeliveryArea[sender.tag]
    objVC.area = data["name"].stringValue
    objVC.price = data["price"].stringValue
    objVC.areaId = data["id"].stringValue
    self.navigationController?.pushViewController(objVC, animated: true)
  }
}

extension DeliveryAreaVC {

  // MARK: - getdeliveryarea api calling
  func Webservice_getdeliveryarea(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      let status = jsonResponce!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponce!["data"].arrayValue
        self.arrDeliveryArea = jsondata
        self.tableview_deliveryArea.reloadData()
        self.tableview_deliveryArea.delegate = self
        self.tableview_deliveryArea.dataSource = self
        self.height_tableview_deliveryArea.constant = CGFloat(self.arrDeliveryArea.count*70)
        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }

  // MARK: - Webservice_DeleteDeliveryData api calling
  func Webservice_DeleteDeliveryData(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1" {

        let urlString = "https://store-mart.paponapps.co.in/api/getdeliveryarea"
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
        self.Webservice_getdeliveryarea(url: urlString, params: params)
        let jsondata = jsonResponse!["data"].arrayValue
        self.tableview_deliveryArea.reloadData()
        showAlertMsg(Message: jsonResponse!["message"].stringValue, AutoHide: true)
        print(jsondata)
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}
