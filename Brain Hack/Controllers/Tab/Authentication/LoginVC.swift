import UIKit
import CoreData
import NVActivityIndicatorView

class LoginVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    var arrUserData = [NSManagedObject]()
    
    @IBOutlet weak var textfield_email: UITextField!
    @IBOutlet weak var textfiled_password: UITextField!
    @IBOutlet weak var btn_eye: UIButton!
    @IBOutlet weak var view_loader: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.setLoader()
        }
    }
    
    @IBAction func btnTap_back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnTap_eye(_ sender: UIButton) {
        
    }
    
    @IBAction func btnTap_login(_ sender: UIButton) {
        if self.textfield_email.text == "" {
            showAlertMsg(Message: CONSTANT.MSG_EMAIL, AutoHide: true)
        }
        else if self.textfiled_password.text == "" {
            showAlertMsg(Message: CONSTANT.MSG_PAASWORD, AutoHide: true)
        }
        else if self.textfield_email.text == "" && self.textfiled_password.text == "" {
            showAlertMsg(Message: "Please enter all details", AutoHide: true)
        }
        else {
            fetchData()
        }
    }
    
    @IBAction func btnTap_Guest(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TabVC") as! TabVC
        self.navigationController?.pushViewController(vc, animated: true)
        CONSTANT.GUEST_USER = true
    }
    
    @IBAction func btnTap_signup(_ sender: UIButton) {
        let vc = MainstoryBoard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginVC {
    
    func fetchData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CONSTANT.DATA_ENTITY)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "email") as? String == self.textfield_email.text! && data.value(forKey: "password") as? String == self.textfiled_password.text! {
                    UserDefaultManager.setStringToUserDefaults(value: data.value(forKey: "name")! as! String, key: CONSTANT.UD_UserName)
                    CONSTANT.GUEST_USER = false
                    showAlertMsg(Message: CONSTANT.MSG_SUCCESS_LOGIN, AutoHide: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        let vc = MainstoryBoard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    localNotification()
                }
                else {
                    showAlertMsg(Message: "Invalid Details", AutoHide: true)
                }
                print(data)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

extension LoginVC {
    func setLoader() {
        self.view_loader.type = .ballSpinFadeLoader
        self.view_loader.color = UIColor(named: "Primary_color_2")!
        self.view_loader.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view_loader.stopAnimating()
        }
    }
}

extension LoginVC {
    func localNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Notifiaction on a certail date"
        content.body = "This is a local notification on certain date"
        content.sound = .default
        content.userInfo = ["value": "Data with local notification"]
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(10))
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
    }
}
