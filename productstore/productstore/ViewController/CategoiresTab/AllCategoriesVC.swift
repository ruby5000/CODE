import UIKit
import SwiftyJSON

class AllCategoriesCell : UITableViewCell {
    @IBOutlet weak var lbl_categories: UILabel!
    @IBOutlet weak var img_catimage: UIImageView!
    @IBOutlet weak var btn_Find: UIButton!
}

class AllCategoriesVC: UIViewController,UIScrollViewDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var img_bgImage: UIImageView!
    @IBOutlet weak var View_Circle: UIView!
    @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
    @IBOutlet weak var Tableview_CategoriesList: UITableView!
    @IBOutlet weak var list_scrollview: UIScrollView!
    
    @IBOutlet weak var View_1: UIView!
    @IBOutlet weak var View_2: UIView!
    @IBOutlet weak var View_3: UIView!
    @IBOutlet weak var View_4: UIView!
    
    //MARK: - View_1
    @IBOutlet weak var cate_1_view_1: UILabel!
    @IBOutlet weak var btn_cate_1_view_1: UIButton!
    
    //MARK: - View_2
    @IBOutlet weak var cate_1_view_2: UILabel!
    @IBOutlet weak var btn_cate_1_view_2: UIButton!
    
    @IBOutlet weak var cate_2_view_2: UILabel!
    @IBOutlet weak var btn_cate_2_view_2: UIButton!
    
    //MARK: - View_3
    @IBOutlet weak var cate_1_view_3: UILabel!
    @IBOutlet weak var btn_cate_1_view_3: UIButton!
    
    @IBOutlet weak var cate_2_view_3: UILabel!
    @IBOutlet weak var btn_cate_2_view_3: UIButton!
    
    @IBOutlet weak var cate_3_view_3: UILabel!
    @IBOutlet weak var btn_cate_3_view_3: UIButton!
    
    //MARK: - View_4
    @IBOutlet weak var cate_1_view_4: UILabel!
    @IBOutlet weak var btn_cate_1_view_4: UIButton!
    
    @IBOutlet weak var cate_2_view_4: UILabel!
    @IBOutlet weak var btn_cate_2_view_4: UIButton!
    
    @IBOutlet weak var cate_3_view_4: UILabel!
    @IBOutlet weak var btn_cate_3_view_4: UIButton!
    
    @IBOutlet weak var cate_4_view_4: UILabel!
    @IBOutlet weak var btn_cate_4_view_4: UIButton!
    @IBOutlet weak var lbl_count: UILabel!
    
    @IBOutlet weak var btn_Back: UIButton!
    
    //MARK: Variables
    var isSelectedAgain = Bool()
    var isnavigatehome = String()
    var Home_Categories_Array = [[String:String]]()
    var pageIndex = 1
    var lastIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isnavigatehome == "1"
        {
            self.btn_Back.isHidden = false
        }
        else{
            self.btn_Back.isHidden = true
        }
        self.View_1.isHidden = true
        self.View_2.isHidden = true
        self.View_3.isHidden = true
        self.View_4.isHidden = true
        self.list_scrollview.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(_:)), name: Notification.Name(rawValue: "NOTIFICATION_CENTER_TAB"), object: nil)
    }
    
    @objc func notificationReceived(_ noti: Notification) {
        isSelectedAgain = true
        if isSelectedAgain{
            UIView.animate(withDuration: 0.3) {
                self.View_Circle.isHidden = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cornerRadius(viewName: self.lbl_count, radius: self.lbl_count.frame.height / 2)
        self.lbl_count.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CartCount)
        self.tabBarController?.tabBar.isHidden = false
        self.View_Circle.isHidden = false
        self.pageIndex = 1
        self.lastIndex = 0
        let urlString = API_URL + "home-categoty?page=\(self.pageIndex)"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary =  ["theme_id":APP_THEME]
        self.Webservice_category(url: urlString, params: params, header: headers)
        
    }
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTap_cart(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTap_Close(_ sender: UIButton) {
        self.View_Circle.isHidden = true
    }
    
    // MARK: - View_1
    @IBAction func btnTap_cate_1_view_1(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = self.Home_Categories_Array[0]["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - View_2
    @IBAction func btnTap_cate_1_view_2(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = self.Home_Categories_Array[0]["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTap_cate_2_view_2(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = self.Home_Categories_Array[1]["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - View_3
    @IBAction func btnTap_cate_1_view_3(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = self.Home_Categories_Array[0]["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTap_cate_2_view_3(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = self.Home_Categories_Array[1]["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTap_cate_3_view_3(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = self.Home_Categories_Array[2]["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - View_4
    @IBAction func btnTap_cate_1_view_4(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = self.Home_Categories_Array[0]["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTap_cate_2_view_4(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = self.Home_Categories_Array[1]["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTap_cate_3_view_4(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = self.Home_Categories_Array[2]["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnTap_cate_4_view_4(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = self.Home_Categories_Array[3]["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    var lastContentOffset: CGFloat = 0
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            self.View_Circle.isHidden = true
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            
        } else {
            
        }
    }
}

//MARK: Tableview Methods
extension AllCategoriesVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Home_Categories_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.Tableview_CategoriesList.dequeueReusableCell(withIdentifier: "AllCategoriesCell") as! AllCategoriesCell
        let data = self.Home_Categories_Array[indexPath.item]
        cornerRadius(viewName: cell.img_catimage, radius: 8.0)
        cell.lbl_categories.text = data["name"]!
        cell.img_catimage.sd_setImage(with: URL(string: IMG_URL + data["image_path"]!), placeholderImage: UIImage(named: "ic_placeholder"))
        cell.btn_Find.tag = indexPath.row
        cell.btn_Find.addTarget(self, action: #selector(btnTap_Find), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let data = self.Home_Categories_Array[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = data["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func btnTap_Find(sender:UIButton)
    {
        let data = self.Home_Categories_Array[sender.tag]
        let vc = self.storyboard?.instantiateViewController(identifier: "AllProductsVC") as! AllProductsVC
        vc.maincategory_id = data["id"]!
        vc.ishome = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: Api Calling Function
extension AllCategoriesVC
{
    func Webservice_category(url:String, params:NSDictionary, header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].dictionaryValue
                if self.pageIndex == 1 {
                    self.lastIndex = Int(jsondata["last_page"]!.stringValue)!
                    self.Home_Categories_Array.removeAll()
                }
                let Featuredprodcutdata = jsondata["data"]!.arrayValue
                
                for data in Featuredprodcutdata
                {
                    let productObj = ["id":data["id"].stringValue,"name":data["name"].stringValue,"image_path":data["image_path"].stringValue,"status":data["status"].stringValue,"category_id":data["category_id"].stringValue,"category_item":data["category_item"].stringValue,"icon_path":data["icon_path"].stringValue]
                    self.Home_Categories_Array.append(productObj)
                }
                let first4 = Array(self.Home_Categories_Array.prefix(4))
                if first4.count == 1
                {
                    self.View_1.isHidden = false
                    self.cate_1_view_1.text = self.Home_Categories_Array[0]["name"]!
                    let cateimage_1 = UIImageView()
                    cateimage_1.sd_setImage(with: URL(string: IMG_URL + self.Home_Categories_Array[0]["icon_path"]!), placeholderImage: UIImage(named: ""))
                    
                    
                    self.btn_cate_1_view_1.setImage(cateimage_1.image, for: .normal)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.btn_cate_1_view_1.setImage(cateimage_1.image, for: .normal)
                    }
                    
                    cornerRadius(viewName: self.btn_cate_1_view_1, radius: self.btn_cate_1_view_1.frame.height / 2)
                    
                }
                if first4.count == 2
                {
                    self.View_2.isHidden = false
                    self.cate_1_view_2.text = self.Home_Categories_Array[0]["name"]!
                    self.cate_2_view_2.text = self.Home_Categories_Array[1]["name"]!
                    let cateimage_1 = UIImageView()
                    let cateimage_2 = UIImageView()
                    
                    cateimage_1.sd_setImage(with: URL(string: IMG_URL + self.Home_Categories_Array[0]["icon_path"]!), placeholderImage: UIImage(named: ""))
                    cateimage_2.sd_setImage(with: URL(string: IMG_URL + self.Home_Categories_Array[1]["icon_path"]!), placeholderImage: UIImage(named: ""))
                    
                    
                    self.btn_cate_1_view_2.setImage(cateimage_1.image, for: .normal)
                    self.btn_cate_2_view_2.setImage(cateimage_2.image, for: .normal)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.btn_cate_1_view_2.setImage(cateimage_1.image, for: .normal)
                        self.btn_cate_2_view_2.setImage(cateimage_2.image, for: .normal)
                    }
                    cornerRadius(viewName: self.btn_cate_1_view_2, radius: self.btn_cate_1_view_2.frame.height / 2)
                    cornerRadius(viewName: self.btn_cate_2_view_2, radius: self.btn_cate_2_view_2.frame.height / 2)
                    
                }
                if first4.count == 3
                {
                    self.View_3.isHidden = false
                    self.cate_1_view_3.text = self.Home_Categories_Array[0]["name"]!
                    self.cate_2_view_3.text = self.Home_Categories_Array[1]["name"]!
                    self.cate_3_view_3.text = self.Home_Categories_Array[2]["name"]!
                    let cateimage_1 = UIImageView()
                    let cateimage_2 = UIImageView()
                    let cateimage_3 = UIImageView()
                    cateimage_1.sd_setImage(with: URL(string: IMG_URL + self.Home_Categories_Array[0]["icon_path"]!), placeholderImage: UIImage(named: ""))
                    cateimage_2.sd_setImage(with: URL(string: IMG_URL + self.Home_Categories_Array[1]["icon_path"]!), placeholderImage: UIImage(named: ""))
                    cateimage_3.sd_setImage(with: URL(string: IMG_URL + self.Home_Categories_Array[2]["icon_path"]!), placeholderImage: UIImage(named: ""))
                    
                    
                    self.btn_cate_1_view_3.setImage(cateimage_1.image, for: .normal)
                    self.btn_cate_2_view_3.setImage(cateimage_2.image, for: .normal)
                    self.btn_cate_3_view_3.setImage(cateimage_3.image, for: .normal)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.btn_cate_1_view_3.setImage(cateimage_1.image, for: .normal)
                        self.btn_cate_2_view_3.setImage(cateimage_2.image, for: .normal)
                        self.btn_cate_3_view_3.setImage(cateimage_3.image, for: .normal)
                    }
                    
                    cornerRadius(viewName: self.btn_cate_1_view_3, radius: self.btn_cate_1_view_3.frame.height / 2)
                    cornerRadius(viewName: self.btn_cate_2_view_3, radius: self.btn_cate_2_view_3.frame.height / 2)
                    cornerRadius(viewName: self.btn_cate_3_view_3, radius: self.btn_cate_3_view_3.frame.height / 2)
                }
                if first4.count == 4
                {
                    self.View_4.isHidden = false
                    
                    cornerRadius(viewName: self.btn_cate_1_view_4, radius: self.btn_cate_1_view_4.frame.height / 2)
                    cornerRadius(viewName: self.btn_cate_2_view_4, radius: self.btn_cate_2_view_4.frame.height / 2)
                    cornerRadius(viewName: self.btn_cate_3_view_4, radius: self.btn_cate_3_view_4.frame.height / 2)
                    cornerRadius(viewName: self.btn_cate_4_view_4, radius: self.btn_cate_4_view_4.frame.height / 2)
                    
                    self.cate_1_view_4.text = self.Home_Categories_Array[0]["name"]!
                    self.cate_2_view_4.text = self.Home_Categories_Array[1]["name"]!
                    self.cate_3_view_4.text = self.Home_Categories_Array[2]["name"]!
                    self.cate_4_view_4.text = self.Home_Categories_Array[3]["name"]!
                    
                    let cateimage_1 = UIImageView()
                    let cateimage_2 = UIImageView()
                    let cateimage_3 = UIImageView()
                    let cateimage_4 = UIImageView()
                    
                    cateimage_1.sd_setImage(with: URL(string: IMG_URL + self.Home_Categories_Array[0]["icon_path"]!), placeholderImage: UIImage(named: ""))
                    cateimage_2.sd_setImage(with: URL(string: IMG_URL + self.Home_Categories_Array[1]["icon_path"]!), placeholderImage: UIImage(named: ""))
                    cateimage_3.sd_setImage(with: URL(string: IMG_URL + self.Home_Categories_Array[2]["icon_path"]!), placeholderImage: UIImage(named: ""))
                    cateimage_4.sd_setImage(with: URL(string: IMG_URL + self.Home_Categories_Array[3]["icon_path"]!), placeholderImage: UIImage(named: ""))
                    
                    self.btn_cate_1_view_4.setImage(cateimage_1.image, for: .normal)
                    self.btn_cate_2_view_4.setImage(cateimage_2.image, for: .normal)
                    self.btn_cate_3_view_4.setImage(cateimage_3.image, for: .normal)
                    self.btn_cate_4_view_4.setImage(cateimage_4.image, for: .normal)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.btn_cate_1_view_4.setImage(cateimage_1.image, for: .normal)
                        self.btn_cate_2_view_4.setImage(cateimage_2.image, for: .normal)
                        self.btn_cate_3_view_4.setImage(cateimage_3.image, for: .normal)
                        self.btn_cate_4_view_4.setImage(cateimage_4.image, for: .normal)
                    }
                    
                }
                self.Tableview_CategoriesList.delegate = self
                self.Tableview_CategoriesList.dataSource = self
                self.Tableview_CategoriesList.reloadData()
                self.Height_Tableview.constant = CGFloat(self.Home_Categories_Array.count * 230)
                
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
