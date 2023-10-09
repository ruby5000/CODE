import UIKit
enum StorageType {
    case userDefaults
}

class profileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_imageClick: UIButton!
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var dob = ""
    var password = ""
    var imageProfile = UIImage()
    var imagePicker = UIImagePickerController()
    var arrUserData = [[String:Any]]()
    var index = 0
    var userArray = UserDefaults.standard.object(forKey: "USER_ARRAY") as! [[String:Any]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_firstName.isUserInteractionEnabled = false
        self.txt_lastName.isUserInteractionEnabled = false
        self.txt_email.isUserInteractionEnabled = false
        self.btn_imageClick.isUserInteractionEnabled = false
        self.txt_firstName.text! = firstName
        self.txt_lastName.text! = lastName
        self.txt_email.text! = email
        //self.img_profile.image = UserDefaults.standard.object(forKey: "IMG") as? UIImage
    }
    
    @IBAction func btnTap_edit(_ sender: UIButton) {
        self.txt_firstName.isUserInteractionEnabled = true
        self.txt_lastName.isUserInteractionEnabled = true
        self.txt_email.isUserInteractionEnabled = true
        self.btn_imageClick.isUserInteractionEnabled = true
    }
    @IBAction func btnTap_update(_ sender: UIButton) {
        let imageData = self.img_profile.image?.jpegData(compressionQuality: 0.0)
        let data = imageData?.base64EncodedString()
        let imgUrl = URL(string: data!)
        var urlString: String = imgUrl!.absoluteString
        print(urlString)
        
        self.arrUserData[index]["fName"] = self.txt_firstName.text!
        self.arrUserData[index]["lName"] = self.txt_lastName.text!
        self.arrUserData[index]["email"] = self.txt_email.text!
        self.arrUserData[index]["img"] = "\(urlString)"
        UserDefaults.standard.set(self.arrUserData, forKey: "USER_ARRAY")
        let userListVC = self.storyboard!.instantiateViewController(withIdentifier: "userListVC") as! userListVC
        navigationController?.pushViewController(userListVC, animated: true)
    }
    
    @IBAction func btnTap_image(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            img_profile.contentMode = .scaleAspectFit
            img_profile.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
