import UIKit
import CoreData
import NVActivityIndicatorView

class SignupVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    
    @IBOutlet weak var btn_eye: UIButton!
    @IBOutlet weak var textfiled_email: UITextField!
    @IBOutlet weak var textfiled_name: UITextField!
    @IBOutlet weak var textfiled_password: UITextField!
    @IBOutlet weak var view_loader: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.saveContext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btnTap_back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnTap_login(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnTap_register(_ sender: UIButton) {
        
        if self.textfiled_email.text == "" {
            showAlertMsg(Message: CONSTANT.MSG_EMAIL, AutoHide: true)
        }
        else if self.textfiled_name.text == "" {
            showAlertMsg(Message: CONSTANT.MSG_NAME, AutoHide: true)
        }
        else if self.textfiled_password.text == "" {
            showAlertMsg(Message: CONSTANT.MSG_PAASWORD, AutoHide: true)
        }
        else if self.textfiled_email.text == "" && self.textfiled_password.text == "" {
            showAlertMsg(Message: "Please enter all details", AutoHide: true)
        }
        else {
            openDatabse()
            self.textfiled_name.text = ""
            self.textfiled_email.text = ""
            self.textfiled_password.text = ""
        }
    }
    
    @IBAction func btnTap_eye(_ sender: UIButton) {
        
    }
    
}

extension SignupVC {
    
    func openDatabse() {
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CONSTANT.DATA_ENTITY, in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        saveData(UserDBObj:newUser)
    }
    
    func saveData(UserDBObj:NSManagedObject) {
        UserDBObj.setValue("\(self.textfiled_email.text!)", forKey: "email")
        UserDBObj.setValue("\(self.textfiled_name.text!)", forKey: "name")
        UserDBObj.setValue("\(self.textfiled_password.text!)", forKey: "password")
        
        do {
            self.setLoader()
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
        fetchData()
    }
    
    func fetchData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CONSTANT.DATA_ENTITY)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                _ = data.value(forKey: "name") as! String
                _ = data.value(forKey: "email") as! String
                _ = data.value(forKey: "password") as! String
                print(data)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

extension SignupVC {
    func setLoader() {
        self.view_loader.type = .ballSpinFadeLoader
        self.view_loader.color = UIColor(named: "Primary_color_2")!
        self.view_loader.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view_loader.stopAnimating()
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: CONSTANT.MSG_SUCCESS_SIGNUP)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
