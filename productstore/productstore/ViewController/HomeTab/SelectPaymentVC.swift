//
//  SelectPaymentVC.swift
//  Fashion
//
//  Created by Gravityinfotech
//

import UIKit
import SwiftyJSON
import SDWebImage

class PaymentCell : UITableViewCell
{
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_paymenttype: UIImageView!
    @IBOutlet weak var cell_view: UIView!
    @IBOutlet weak var img_selected: UIImageView!
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var lbl_Additionalprice: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
}

class SelectPaymentVC: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var Height_Tableview: NSLayoutConstraint!
    @IBOutlet weak var Tableview_PaymentList: UITableView!
    @IBOutlet weak var textView_Description: UITextView!
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var btn_continue: UIButton!
    
    var selectedindex = 0
    var PaymentList_Array = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Tableview_PaymentList.isHidden = true
        self.btn_check.setImage(UIImage.init(systemName: "square"), for: .normal)
        self.btn_continue.isEnabled = false
        self.textView_Description.text = "Description"
        self.textView_Description.textColor = UIColor.lightGray
        self.textView_Description.delegate = self
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
        let urlString = API_URL + "payment-list"
        let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
        let params: NSDictionary = ["theme_id":APP_THEME]
        self.Webservice_PaymentList(url: urlString, params: params, header: headers)
    }
    
}
//MARK: Button Actions
extension SelectPaymentVC
{
    @IBAction func btnTap_Terms(_ sender: UIButton) {
        guard let url = URL(string: UserDefaultManager.getStringFromUserDefaults(key: UD_TermsURL)) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func btnTap_checkmark(_ sender: UIButton) {
        if self.btn_check.imageView?.image == UIImage.init(systemName: "square")
        {
            self.btn_check.setImage(UIImage.init(systemName: "checkmark.square.fill"), for: .normal)
            self.btn_continue.isEnabled = true
        }
        else{
            self.btn_check.setImage(UIImage.init(systemName: "square"), for: .normal)
            self.btn_continue.isEnabled = false
        }
    }
    
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_Continue(_ sender: UIButton) {
        if self.btn_check.imageView?.image == UIImage.init(systemName: "square")
        {
            showAlertMessage(titleStr: "", messageStr: SELECT_TERMSCONDITION_MESAAGE)
        }
        else
        {
            if self.textView_Description.text == "Description"
            {
                self.textView_Description.text = ""
            }
            
            let data = self.PaymentList_Array[selectedindex]
            UserDefaultManager.setStringToUserDefaults(value: data["name"].stringValue, key: UD_PaymentType)
            UserDefaultManager.setStringToUserDefaults(value: data["image"].stringValue, key: UD_PaymentType_Image)
            UserDefaultManager.setStringToUserDefaults(value: self.textView_Description.text!, key: UD_PaymentDescription)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOrderVC") as! ConfirmOrderVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
//MARK: Tableview Methods
extension SelectPaymentVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PaymentList_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.Tableview_PaymentList.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell
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
        
        let data = self.PaymentList_Array[indexPath.row]
        cell.lbl_desc.text = data["detail"].stringValue
        cell.lbl_title.text = data["name_string"].stringValue
        cell.img_paymenttype.sd_setImage(with: URL(string: PAYMENT_URL + data["image"].stringValue), placeholderImage: UIImage(named: ""))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.PaymentList_Array[indexPath.row]
        UserDefaultManager.setStringToUserDefaults(value: data["name"].stringValue, key: UD_PaymentType)
        UserDefaultManager.setStringToUserDefaults(value: data["image"].stringValue, key: UD_PaymentType_Image)
        UserDefaultManager.setStringToUserDefaults(value: data["stripe_publishable_key"].stringValue, key: UD_Stripe_publishable_key)
        
        self.selectedindex = indexPath.item
        self.Tableview_PaymentList.reloadData()
    }
    
}
extension SelectPaymentVC
{
    func Webservice_PaymentList(url:String, params:NSDictionary,header:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1"
            {
                let jsondata = jsonResponse!["data"].arrayValue
                self.PaymentList_Array.removeAll()
                for data in jsondata
                {
                    if data["status"].stringValue == "on"
                    {
                        self.PaymentList_Array.append(data)
                    }
                }
                self.Tableview_PaymentList.delegate = self
                self.Tableview_PaymentList.dataSource = self
                self.Tableview_PaymentList.reloadData()
                self.Tableview_PaymentList.estimatedRowHeight = 120
                self.Tableview_PaymentList.rowHeight = UITableView.automaticDimension
                self.Height_Tableview.constant = CGFloat(150 * self.PaymentList_Array.count)
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
