
import UIKit
import SwiftyJSON
import SDWebImage

class SelectDeliveryVC: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
    @IBOutlet weak var Tableview_PaymentList: UITableView!
    @IBOutlet weak var textview_Deliverydescription: UITextView!
    @IBOutlet weak var btn_continue: UIButton!
    
    var selectedindex = 0
    var ShippingList_Array = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Tableview_PaymentList.isHidden = true
        self.textview_Deliverydescription.text = "Description"
        self.textview_Deliverydescription.textColor = UIColor.lightGray
        self.textview_Deliverydescription.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let urlString = API_URL + "delivery-list"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["theme_id":APP_THEME]
        self.Webservice_ShippingList(url: urlString, params: params, header: headers)
    }
    
}
//MARK: Button action
extension SelectDeliveryVC
{
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_Continue(_ sender: UIButton) {
        
        if self.textview_Deliverydescription.text == "Description"
        {
            self.textview_Deliverydescription.text = ""
        }
        
        let data = self.ShippingList_Array[selectedindex]
        UserDefaultManager.setStringToUserDefaults(value: data["id"].stringValue, key: UD_Deliveryid)
        UserDefaultManager.setStringToUserDefaults(value: data["image_path"].stringValue, key: UD_Delivery_Image)
        UserDefaultManager.setStringToUserDefaults(value: self.textview_Deliverydescription.text!, key: UD_DeliveryDescription)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectPaymentVC") as! SelectPaymentVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
//MARK: Tableview Methods
extension SelectDeliveryVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ShippingList_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.Tableview_PaymentList.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell
        let data = self.ShippingList_Array[indexPath.row]
        if indexPath.row == self.selectedindex
        {
            setBorder(viewName: cell.cell_view, borderwidth: 1.5, borderColor: UIColor.init(named: "Second_Color")!.cgColor, cornerRadius: 10)
            cell.img_selected.image = UIImage(named: "ic_checkfill")
        }
        else
        {
            setBorder(viewName: cell.cell_view, borderwidth: 1.5, borderColor: UIColor.lightGray.cgColor, cornerRadius: 10)
            cell.img_selected.image = UIImage(named: "ic_check")
        }
        cell.lbl_title.text = data["name"].stringValue
        cell.img_paymenttype.sd_setImage(with: URL(string: IMG_URL + data["image_path"].stringValue), placeholderImage: UIImage(named: ""))
        cell.lbl_desc.text = data["description"].stringValue
        if data["charges_type"].stringValue == "percentage"
        {
            let Price = formatter.string(for: data["amount"].stringValue.toDouble)
            cell.lbl_Additionalprice.text = "\(Price!)%"
        }
        else{
            let Price = formatter.string(for: data["amount"].stringValue.toDouble)
            cell.lbl_Additionalprice.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(Price!)"
        }
        
        let dates = DateFormater.getFullDateStringFromString(givenDate: data["expeted_delivery"].stringValue)
        cell.lbl_date.text = "Date:\(dates)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.ShippingList_Array[indexPath.row]
        self.selectedindex = indexPath.item
        self.Tableview_PaymentList.reloadData()
        UserDefaultManager.setStringToUserDefaults(value: data["id"].stringValue, key: UD_Deliveryid)
        UserDefaultManager.setStringToUserDefaults(value: data["image_path"].stringValue, key: UD_Delivery_Image)
    }
    
}
extension SelectDeliveryVC
{
    func Webservice_ShippingList(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].arrayValue
                self.ShippingList_Array = jsondata
                self.Tableview_PaymentList.delegate = self
                self.Tableview_PaymentList.dataSource = self
                self.Tableview_PaymentList.reloadData()
                self.Tableview_PaymentList.estimatedRowHeight = 120
                self.Tableview_PaymentList.rowHeight = UITableView.automaticDimension
                
                self.Height_Tableview.constant = CGFloat(120 * self.ShippingList_Array.count)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.Height_Tableview.constant = self.Tableview_PaymentList.contentSize.height
                    self.Tableview_PaymentList.isHidden = false
                }
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
