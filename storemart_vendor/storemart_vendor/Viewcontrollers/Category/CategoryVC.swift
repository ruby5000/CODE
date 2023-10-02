import UIKit
import SwiftyJSON
import Alamofire

class categoryCell : UITableViewCell {

  @IBOutlet weak var lbl_Categoryname: UILabel!
  @IBOutlet weak var btn_delete: UIButton!
  @IBOutlet weak var btn_edit: UIButton!
}

class CategoryVC: UIViewController {

  @IBOutlet weak var tableview_category: UITableView!
  @IBOutlet weak var height_tableview_category: NSLayoutConstraint!
  @IBOutlet weak var btn_add: UIButton!

  var arrNewCategory = [JSON]()
  var arrTextfiledData : UITextField?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.addShadowInBtn()
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
      let urlString = "https://store-mart.paponapps.co.in/api/getcategory"
      let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
      self.Webservice_Category(url: urlString, params: params)
    }
  }

  // MARK: - addShadowInBtn
  func addShadowInBtn() {
    self.btn_add.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
    self.btn_add.layer.shadowOpacity = 0.5
    self.btn_add.layer.shadowRadius = 4.0
    self.btn_add.layer.shadowColor = UIColor.black.cgColor
  }

  @IBAction func btnAction_add(_ sender: UIButton) {
    self.showAlertMessage(titleStr: "Add Category", messageStr: "Category Name")
  }

  // MARK: - showAlertMessage
  func showAlertMessage(titleStr:String, messageStr:String) -> Void {
    let alertVC = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
    alertVC.addTextField { (textField) in
      self.arrTextfiledData?.placeholder = "Category"
      let submitBtn = UIAlertAction(title: "Submit", style: .default) { (action) in
        self.arrNewCategory.append(JSON(rawValue: textField.text!)!)
        let urlString = "https://store-mart.paponapps.co.in/api/addcategory"
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                    "category_name":textField.text!]
        self.Webservice_AddNewCategory(url: urlString, params: params)
        self.tableview_category.reloadData()
      }
      self.tableview_category.reloadData()
      alertVC.addAction(submitBtn)
    }
    self.present(alertVC,animated: true,completion: nil)
  }

  @objc func dismissOnTapOutside(){
    self.dismiss(animated: true, completion: nil)
  }
}

extension CategoryVC : UITableViewDelegate, UITableViewDataSource {

  // MARK: - heightForRowAt
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }

  // MARK: - numberOfRowsInSection
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.arrNewCategory.count
  }

  // MARK: - cellForRowAt
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! categoryCell
    let data = self.arrNewCategory[indexPath.row]
    cell.lbl_Categoryname?.text = data["name"].stringValue
    cell.btn_delete.tag = indexPath.row
    cell.btn_edit.tag = indexPath.row
    cell.btn_delete.addTarget(self, action: #selector(btnTap_delete), for: .touchUpInside)
    cell.btn_edit.addTarget(self, action: #selector(btnTap_edit), for: .touchUpInside)
    return cell
  }

  // MARK: - trailingSwipeActionsConfigurationForRowAt
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

    // delete
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
      let data = self.arrNewCategory[indexPath.row]
      let urlString = "https://store-mart.paponapps.co.in/api/deletecategory"
      let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                  "cat_id":data["id"].rawValue]
      self.Webservice_DeleteCategory(url: urlString, params: params)
      complete(true)
    }

    // edit
    let editAction = UIContextualAction(style: .destructive, title: "Edit") { _, _, complete in
      let alertVC = UIAlertController(title: "Edit Category", message: "", preferredStyle: .alert)
      let data = self.arrNewCategory[indexPath.row]
      alertVC.addTextField { (EdittextField) in
        EdittextField.text! = data["name"].stringValue

        let submitBtn = UIAlertAction(title: "Submit", style: .default) { (action) in
          let urlString = "https://store-mart.paponapps.co.in/api/editcategory"
          let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                      "category_name":EdittextField.text!,
                                      "slug":data["slug"].stringValue]
          self.Webservice_editCategory(url: urlString, params: params)
          self.tableview_category.reloadData()
        }
        alertVC.addAction(submitBtn)
      }
      self.present(alertVC,animated: true,completion: nil)
      complete(true)
    }

    deleteAction.backgroundColor = .red
    editAction.backgroundColor = .systemGreen

    let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    configuration.performsFirstActionWithFullSwipe = true
    return configuration
  }

  // MARK: - canEditRowAt
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  // MARK: - didSelectRowAt
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //UserDefaultManager.setStringToUserDefaults(value: arrNewCategory[indexPath.row].rawValue as! String, key: UD_CategoryName)
    let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryDetailsVC") as? CategoryDetailsVC
    //    (vc?.tempText = arrNewCategory[indexPath.row]).rawValue
    self.navigationController?.pushViewController(vc!, animated: true)
  }

  // MARK: - btnTap_delete
  @objc func btnTap_delete(sender:UIButton) {
    let data = self.arrNewCategory[sender.tag]
    let urlString = "https://store-mart.paponapps.co.in/api/deletecategory"
    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                "cat_id":data["id"].rawValue]
    self.Webservice_DeleteCategory(url: urlString, params: params)
  }

  // MARK: - btnTap_edit
  @objc func btnTap_edit(sender:UIButton) {
    let alertVC = UIAlertController(title: "Edit Category", message: "", preferredStyle: .alert)
    let data = self.arrNewCategory[sender.tag]
    alertVC.addTextField { (EdittextField) in
      EdittextField.text! = data["name"].stringValue

      let submitBtn = UIAlertAction(title: "Submit", style: .default) { (action) in
        let urlString = "https://store-mart.paponapps.co.in/api/editcategory"
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                    "category_name":EdittextField.text!,
                                    "slug":data["slug"].stringValue]
        self.Webservice_editCategory(url: urlString, params: params)
        self.tableview_category.reloadData()
      }
      alertVC.addAction(submitBtn)
    }
    self.present(alertVC,animated: true,completion: nil)
  }
}


extension CategoryVC {

  // MARK: - Category api calling
  func Webservice_Category(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      let status = jsonResponce!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponce!["data"].arrayValue
        self.arrNewCategory = jsondata
        self.height_tableview_category.constant = CGFloat(self.arrNewCategory.count*50)
        self.tableview_category.reloadData()
        self.tableview_category.delegate = self
        self.tableview_category.dataSource = self
        UserDefaultManager.setStringToUserDefaults(value: jsonResponce!["slug"].stringValue, key: UD_Slug)
        print(jsondata)
      }
      else {
        self.showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }

  // MARK: - add new category api calling
  func Webservice_AddNewCategory(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1" {
        let urlString = "https://store-mart.paponapps.co.in/api/getcategory"
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
          print(UserDefaultManager.getStringFromUserDefaults(key: UD_userId))
        self.Webservice_Category(url: urlString, params: params)
        self.tableview_category.reloadData()
        let jsondata = jsonResponse!["data"].arrayValue
        showAlertMsg(Message: jsonResponse!["message"].stringValue, AutoHide: true)
        //print(jsondata)
      }
      else {
        self.showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }

  // MARK: - delete category api calling
  func Webservice_DeleteCategory(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1" {
        let urlString = "https://store-mart.paponapps.co.in/api/getcategory"
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
        self.Webservice_AddNewCategory(url: urlString, params: params)
          print(params)
        let jsondata = jsonResponse!["data"].arrayValue
        showAlertMsg(Message: jsonResponse!["message"].stringValue, AutoHide: true)
        print(jsondata)
      }
      else {
        self.showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }

  // MARK: - edit category api calling
  func Webservice_editCategory(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true)
    {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1" {
        let urlString = "https://store-mart.paponapps.co.in/api/getcategory"
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
        self.Webservice_AddNewCategory(url: urlString, params: params)
        let jsondata = jsonResponse!["data"].arrayValue
        showAlertMsg(Message: jsonResponse!["message"].stringValue, AutoHide: true)
        print(jsondata)
      }
      else {
        self.showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}
