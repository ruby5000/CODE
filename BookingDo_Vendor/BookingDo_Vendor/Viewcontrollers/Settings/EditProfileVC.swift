import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD
import SDWebImage


class EditProfileVC: UIViewController {

  @IBOutlet weak var txt_name: UITextField!
  @IBOutlet weak var txt_email: UITextField!
  @IBOutlet weak var txt_mobileNumber: UITextField!
  @IBOutlet weak var img_profileImage: UIImageView!

  var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
      self.txt_name.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userFullname)
      self.txt_email.text = UserDefaultManager.getStringFromUserDefaults(key: UD_emailId)
      self.txt_mobileNumber.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userPhone)
      self.img_profileImage.sd_setImage(with: URL(string: UserDefaultManager.getStringFromUserDefaults(key: UD_Userprofile)), placeholderImage: UIImage(named: "ic_placeholder"))
    }
    
  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func btnTap_editImage(_ sender: UIButton) {
    if UserDefaultManager.getStringFromUserDefaults(key: UD_Userprofile) == ""
    {
      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      let objVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
      let nav : UINavigationController = UINavigationController(rootViewController: objVC)
      nav.navigationBar.isHidden = true
      keyWindow?.rootViewController = nav
    }
    else
    {
      self.imagePicker.delegate = self
      self.imagePicker.allowsEditing = true
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

  @IBAction func btnTap_Update(_ sender: UIButton) {
    if self.txt_name.text == "" {
      showAlertMessage(titleStr: "", messageStr: "enter full name")
    }
    if self.txt_email.text! == "" {
      showAlertMessage(titleStr: "", messageStr: "enter email")
    }
    if self.txt_mobileNumber.text! == "" {
      showAlertMessage(titleStr: "", messageStr: "enter mobile number")
    }
    else {
      let urlString = "http://192.168.1.28/bookingdo/api/editprofile"
      let params: NSDictionary = ["vendor_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                  "name":self.txt_name.text!,
                                  "mobile":self.txt_mobileNumber.text!,
                                  "email":self.txt_email.text!,
                                  "image":UserDefaultManager.getStringFromUserDefaults(key: UD_Userprofile)]
      self.Webservice_editprofile(url: urlString, params: params)
    }
  }
}

extension EditProfileVC {
  func Webservice_editprofile(url:String, params:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters: params, httpMethod: "POST", progressView: true, uiView: self.view, networkAlert: true)
    { jsonResponce, strErrorMessage in
      if strErrorMessage.count != 0 {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
      }
      else {
        let responseCode = jsonResponce!["status"].stringValue
        if responseCode == "1" {
          UserDefaultManager.setStringToUserDefaults(value: self.txt_name.text!, key: UD_userFullname)
          UserDefaultManager.setStringToUserDefaults(value: self.txt_mobileNumber.text!, key: UD_userPhone)
          UserDefaultManager.setStringToUserDefaults(value: self.txt_email.text!, key: UD_emailId)
          self.navigationController?.popViewController(animated: true)
        }
        else {
          showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      self.img_profileImage.image = pickedImage
    }
    self.dismiss(animated: true, completion: nil)

    MBProgressHUD.showAdded(to: self.view, animated: true)
    let imageData = self.img_profileImage.image!.jpegData(compressionQuality: 0.0)

    let urlString = "http://192.168.1.28/bookingdo/api/editprofile"
    let params = ["vendor_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                  "name":self.txt_name.text!,
                  "mobile":self.txt_mobileNumber.text!,
                  "email":self.txt_email.text!,
                  "image":imageData!] as [String : Any]
    let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Accept":"application/json","Authorization":"Bearer \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
    WebServices().multipartWebService(method:.post, URLString:urlString, encoding:JSONEncoding.default, parameters:params, fileData:imageData!, fileUrl:nil, headers:headers, keyName:"image") { (response, error,statusCode)  in

      MBProgressHUD.hide(for: self.view, animated: false)

      if error != nil {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: error!.localizedDescription)
      }
      else {
        if statusCode == "1"
        {
          let data = response!["data"] as! NSDictionary
          self.img_profileImage.sd_setImage(with: URL(string:"\(data["message"] as! String)"), placeholderImage: UIImage(named: "ic_placeholder"))
          UserDefaultManager.setStringToUserDefaults(value: "\(data["message"] as! String)", key: UD_Userprofile)

        }
        else if statusCode == "0"
        {
          UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
          UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
          let storyBoard = UIStoryboard(name: "Main", bundle: nil)
          let objVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
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
