import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import iOSDropDown
import GoogleSignIn


class SignInVC: UIViewController {

    @IBOutlet weak var txt_countryName: DropDown!
    @IBOutlet weak var img_countryFlag: UIImageView!

    var arrName = [String]()
    var arrEmoji = [String]()
    var GoogleClient_Id = "981101338131-7drq025igtrhbsai9gsqh0u3r0pb6ugl.apps.googleusercontent.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryNameAPI(url: API.COUNTRY_NAME_API)
    }
    
    @IBAction func txt_CountryName(_ sender: DropDown) {
        sender.optionArray = arrName
        sender.textColor = .black
        sender.checkMarkEnabled = false
        sender.resignFirstResponder()
        sender.isSearchEnable = false
        sender.didSelect { selectedText, index, id in
            print(selectedText)
            print(self.arrEmoji)
        }
    }
    @IBAction func btnTap_google(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "NumberVC") as! NumberVC
//        self.navigationController?.pushViewController(vc, animated: true)
        googleLogin()
    }
    
    @IBAction func btnTap_FB(_ sender: UIButton) {
        
    }
}



extension SignInVC {
    func countryNameAPI(url:String) {
        APIService().CallGlobalAPI(url: url, httpMethod: "GET", headers: [:], parameters: [:]) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let jsonData = jsonResponse!.arrayValue
            for i in jsonData {
                self.arrName.append(i["name"].stringValue)
                self.arrEmoji.append(i["emoji"].stringValue)
            }
        }
    }
}

extension SignInVC {
    func googleLogin() {
        let signInConfig = GIDConfiguration.init(clientID: GoogleClient_Id)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if error != nil {
                
            }
            else {
                guard let user = user else { return }
                print(user.userID!)
                print(user.profile?.name ?? "")
                print(user.profile?.email ?? "")
                UserDefaults.standard.set(user.profile?.email, forKey: "EMAIL")
                UserDefaults.standard.set(user.profile?.name, forKey: "NAME")
                IS_GOOGLE_LOGIN = true
            }
            guard error == nil else { return }
        }
    }
}
