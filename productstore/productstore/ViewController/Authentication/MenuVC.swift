

import UIKit
import SwiftyJSON
import SDWebImage

protocol ProductListDelegate {
    func getdata(subcategory_id:String,maincategory_id:String,categories_name:String)
}

class MenuCell : UITableViewCell
{
    @IBOutlet weak var img_Categories: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
}

class MenuVC: UIViewController {
    
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var Tableview_MenuList: UITableView!
    var menuListArray = [JSON]()
    var delegate: ProductListDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            self.btn_login.isHidden = false
        }
        else{
            self.btn_login.isHidden = true
        }
        let urlString = API_URL + "navigation"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["theme_id":APP_THEME]
        self.Webservice_navigation(url: urlString, params: params, header: headers)
    }
}
//MARK: Button actions
extension MenuVC
{
    @IBAction func btnTap_youtube(_ sender: UIButton) {
        guard let url = URL(string: UserDefaultManager.getStringFromUserDefaults(key: UD_YoutubeURL)) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func btnTap_msg(_ sender: UIButton) {
        guard let url = URL(string: UserDefaultManager.getStringFromUserDefaults(key: UD_MessageURL)) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func btnTap_insta(_ sender: UIButton) {
        guard let url = URL(string: UserDefaultManager.getStringFromUserDefaults(key: UD_InstaURL)) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func btnTap_twitter(_ sender: UIButton) {
        guard let url = URL(string: UserDefaultManager.getStringFromUserDefaults(key: UD_TwitterURL)) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func btnTap_Close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTap_Login(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        let nav : UINavigationController = UINavigationController(rootViewController: objVC)
        nav.navigationBar.isHidden = true
        keyWindow?.rootViewController = nav
    }
}

//MARK: Tableview Methods
extension MenuVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuListArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.Tableview_MenuList.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        let data = self.menuListArray[indexPath.row]
        cell.lbl_title.text = data["name"].stringValue
        //        cell.img_Categories.sd_setImage(with: URL(string: IMG_URL + data["icon_img_path"].stringValue), placeholderImage: UIImage(named: ""))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.menuListArray[indexPath.row]
        
        self.dismiss(animated: true) {
            self.delegate.getdata(subcategory_id: "", maincategory_id: data["id"].stringValue, categories_name: data["name"].stringValue)
        }
        
    }
}

//MARK: Api Calling Function
extension MenuVC
{
    func Webservice_navigation(url:String, params:NSDictionary, header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                self.menuListArray = jsonResponse!["data"].arrayValue
                self.Tableview_MenuList.delegate = self
                self.Tableview_MenuList.dataSource = self
                self.Tableview_MenuList.reloadData()
            }
            
            else if status == "9"
            {
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_TokenType)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else
            {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
}

