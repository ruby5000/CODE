import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD
import SDWebImage

class SettingsCell : UITableViewCell
{
    @IBOutlet weak var lbl_subtitle: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_images: UIImageView!
}
class SettingsVC: UIViewController {
    
    @IBOutlet weak var Tableview_SettingsList: UITableView!
    @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_count: UILabel!
    
    var imagePicker = UIImagePickerController()
    var TitleArray = [String]()
    var SubtitleArray = [String]()
    var ImagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius(viewName: self.lbl_count, radius: self.lbl_count.frame.height / 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
        self.tabBarController?.tabBar.isHidden = false
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            keyWindow?.rootViewController = nav
        }
        else{
            
            self.lbl_Name.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userFullname)
            self.lbl_email.text = UserDefaultManager.getStringFromUserDefaults(key: UD_emailId)
            self.img_profile.sd_setImage(with: URL(string: PAYMENT_URL + UserDefaultManager.getStringFromUserDefaults(key: UD_Userprofile)), placeholderImage: UIImage(named: "ic_placeholder"))
            
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                self.TitleArray = ["Edit your account information","Change your password","Modify your address book entries","View your order history","Login"]
                self.SubtitleArray = ["Edit your account","Change Your Passowrd","Edit your address","See your order history","Login app"]
                self.ImagesArray = ["ic_user","ic_Changepwd","ic_address","ic_orderhistory","ic_logout"]
            }
            else{
                self.TitleArray = ["Edit your account information","Change your password","Modify your address book entries","View your order history","My Returns","Loyality Program","Logout"]
                self.SubtitleArray = ["Edit your account","Change Your Passowrd","Edit your address","See your order history","See your Return","Get cash by following people","Logout app"]
                self.ImagesArray = ["ic_user","ic_Changepwd","ic_address","ic_orderhistory","ic_returnorder","ic_Loyality","ic_logout"]
            }
            
            self.Tableview_SettingsList.dataSource = self
            self.Tableview_SettingsList.delegate = self
            self.Tableview_SettingsList.reloadData()
            self.Height_Tableview.constant = CGFloat(TitleArray.count * 75)
        }
    }
}
extension SettingsVC : ProductListDelegate
{
    func getdata(subcategory_id: String, maincategory_id: String, categories_name: String) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = maincategory_id
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Button Actions
extension SettingsVC
{
    @IBAction func btnTap_UpdateProfile(_ sender: UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            keyWindow?.rootViewController = nav
        }
        else
        {
            self.imagePicker.delegate = self
            let alert = UIAlertController(title: Bundle.main.displayName!, message: "Select image", preferredStyle: .actionSheet)
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default) { (action) in
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(photoLibraryAction)
            alert.addAction(cameraAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnTap_Cart(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTap_Menu(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnTap_Editprofile(_ sender: UIButton)
    {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            keyWindow?.rootViewController = nav
        }
        else{
            let vc = MainstoryBoard.instantiateViewController(withIdentifier: "PersonalDetailsVC") as! PersonalDetailsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
//MARK: Tableview Methods
extension SettingsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TitleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.Tableview_SettingsList.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
        cell.lbl_title.text = self.TitleArray[indexPath.row]
        cell.lbl_subtitle.text = self.SubtitleArray[indexPath.row]
        cell.img_images.image = UIImage(named: self.ImagesArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else
            {
                let vc = MainstoryBoard.instantiateViewController(withIdentifier: "PersonalDetailsVC") as! PersonalDetailsVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else if indexPath.row == 1
        {
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else
            {
                let vc = MainstoryBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else if indexPath.row == 2
        {
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else
            {
                let vc = MainstoryBoard.instantiateViewController(withIdentifier: "AddressListVC") as! AddressListVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else if indexPath.row == 3
        {
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else
            {
                let vc = MainstoryBoard.instantiateViewController(withIdentifier: "OrderHistoryVC") as! OrderHistoryVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if indexPath.row == 4
        {
            let vc = MainstoryBoard.instantiateViewController(withIdentifier: "MyReturnsVC") as! MyReturnsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 5
        {
            let vc = MainstoryBoard.instantiateViewController(withIdentifier: "LoyalityprogramVC") as! LoyalityprogramVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 6
        {
            if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == ""
            {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
            }
            else{
                let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "Are you sure to logout from this app?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    
                    let urlString = API_URL + "logout"
                    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),"theme_id":APP_THEME]
                    self.Webservice_LogoutApp(url: urlString, params: params, header: headers)
                    
                }
                let noAction = UIAlertAction(title: "No", style: .destructive)
                alertVC.addAction(noAction)
                alertVC.addAction(yesAction)
                self.present(alertVC,animated: true,completion: nil)
            }
        }
    }
}

//MARK: Functions
extension SettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.img_profile.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let imageData = self.img_profile.image!.jpegData(compressionQuality: 0.0)
        let urlString = API_URL + "update-user-image"
        let params = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                      "image":imageData!,"theme_id":APP_THEME] as [String : Any]
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Accept":"application/json","Authorization":"Bearer \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        
        WebServices().multipartWebService(method:.post, URLString:urlString, encoding:JSONEncoding.default, parameters:params, fileData:imageData!, fileUrl:nil, headers:headers, keyName:"image") { (response, error,statusCode)  in
            
            MBProgressHUD.hide(for: self.view, animated: false)
            
            if error != nil {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: error!.localizedDescription)
            }
            else {
                if statusCode == "200"
                {
                    let data = response!["data"] as! NSDictionary
                  print(data["message"] as! String)
                    self.img_profile.sd_setImage(with: URL(string: PAYMENT_URL + "\(data["message"] as! String)"), placeholderImage: UIImage(named: "ic_placeholder"))
                    UserDefaultManager.setStringToUserDefaults(value: "\(data["message"] as! String)", key: UD_Userprofile)
                }
                else if statusCode == "401"
                {
                    UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
                    UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                    let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                    nav.navigationBar.isHidden = true
                    keyWindow?.rootViewController = nav
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: (response!["message"] as! String).replacingOccurrences(of: "\\n", with: "\n"))
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK: Api calling
extension SettingsVC
{
    func Webservice_LogoutApp(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers:header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
                UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                keyWindow?.rootViewController = nav
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
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
            }
        }
    }
}
