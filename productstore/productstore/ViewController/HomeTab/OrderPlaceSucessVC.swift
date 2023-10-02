
import UIKit
class OrderPlaceSucessVC: UIViewController {
    
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_orderNumber: UILabel!
    var toptitle = String()
    var desc = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let MainTitle = self.toptitle
        let MainTitleArr = MainTitle.components(separatedBy: "#")
        self.lbl_title.text = MainTitleArr[0]
        self.lbl_orderNumber.text = "#\(MainTitleArr[1])"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelDidGetTapped))
        self.lbl_orderNumber.isUserInteractionEnabled = true
        self.lbl_orderNumber.addGestureRecognizer(tapGesture)
        self.lbl_description.text = self.desc
    }
    
    @objc
    func labelDidGetTapped(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        UIPasteboard.general.string = label.text
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr:"Order number copied!")
    }
    
    @IBAction func btnTap_Backtoshop(_ sender: UIButton) {
        UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestObj)
        UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestProductArray)
        UserDefaultManager.setCustomObjToUserDefaultsGuest(CustomeObj: [[String:String]](), key: UD_GuestTaxArray)
        UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_GuestTaxArray)
        UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_CouponObj)
        UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: [:], key: UD_BillingObj)
        
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_PaymentType)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_PaymentDescription)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_Deliveryid)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_DeliveryDescription)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_CartCount)
        
        let objVC = MainstoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let TabViewController = MainstoryBoard.instantiateViewController(withIdentifier: "TababrVC") as! TababrVC
        let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
        appNavigation.setNavigationBarHidden(true, animated: true)
        keyWindow?.rootViewController = TabViewController
        
    }
    
}
