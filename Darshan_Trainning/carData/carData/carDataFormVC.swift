import UIKit

struct CarData {
    let company: String
    let name: String
    let mfgYear: String
    let color: String
    let price: String
    let img: UIImage?
}

class carDataFormVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var txt_companyName: UITextField!
    @IBOutlet weak var txt_carName: UITextField!
    @IBOutlet weak var txt_mfgYear: UITextField!
    @IBOutlet weak var txt_color: UITextField!
    @IBOutlet weak var txt_price: UITextField!
    @IBOutlet weak var img_carImage: UIImageView!
    
    var arrCarData = [CarData]()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func alert_txt_validation(message:String) {
        let alert = UIAlertController(title: "ALERT!", message: message, preferredStyle: .alert)
        let btn_ok = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { UIAlertAction in }
        alert.addAction(btn_ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.txt_companyName.text! = ""
        self.txt_carName.text! = ""
        self.txt_mfgYear.text! = ""
        self.txt_color.text! = ""
        self.txt_price.text! = ""
        self.img_carImage.image = UIImage(named: "ic_placeholder")
    }
    
    func imgSelect() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            img_carImage.contentMode = .scaleAspectFit
            img_carImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnTap_submit(_ sender: UIButton) {
        if self.txt_companyName.text! == "" && self.txt_price.text! == "" && self.txt_color.text! == "" &&  self.txt_mfgYear.text! == "" && self.txt_carName.text! == "" {
            self.alert_txt_validation(message: "Please enter all details")
        }
        else if self.txt_companyName.text! == "" {
            self.alert_txt_validation(message: "Please enter company name")
        }
        else if self.txt_carName.text! == "" {
            self.alert_txt_validation(message: "Please enter price")
        }
        else if self.txt_mfgYear.text! == "" {
            self.alert_txt_validation(message: "Please enter color")
        }
        else if self.txt_color.text! == "" {
            self.alert_txt_validation(message: "Please enter mfg year")
        }
        else if self.txt_price.text! == "" {
            self.alert_txt_validation(message: "Please enter car name")
        }
        else {
            self.arrCarData.append(CarData(company: self.txt_companyName.text!, name: self.txt_carName.text!, mfgYear: self.txt_mfgYear.text!, color: self.txt_color.text!, price: self.txt_price.text!, img: self.img_carImage.image!))
            
            
        }
    }
    
    @IBAction func btnTap_list(_ sender: UIButton) {
        let objVC = self.storyboard!.instantiateViewController(withIdentifier: "carListVC") as! carListVC
        objVC.arrCarDetails = self.arrCarData
        navigationController?.pushViewController(objVC, animated: true)
    }
    @IBAction func btnTap_selectPhoto(_ sender: UIButton) {
        self.imgSelect()
    }
}
