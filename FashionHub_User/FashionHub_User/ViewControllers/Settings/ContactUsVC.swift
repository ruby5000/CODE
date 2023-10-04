import UIKit

class ContactUsVC: UIViewController {

  @IBOutlet weak var txt_firstName: UITextField!
  @IBOutlet weak var txt_lastName: UITextField!
  @IBOutlet weak var txt_phoneNumber: UITextField!
  @IBOutlet weak var txt_AdditionalInfo: UITextField!

  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    self.txt_firstName.placeHolderColor = .lightGray
    self.txt_lastName.placeHolderColor = .lightGray
    self.txt_phoneNumber.placeHolderColor = .lightGray
    self.txt_AdditionalInfo.placeHolderColor = .lightGray
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
}
