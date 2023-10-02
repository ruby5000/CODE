import UIKit

class AddNewProductVC: UIViewController {

  @IBOutlet weak var txt_Category: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.txt_Category.text = UserDefaultManager.getStringFromUserDefaults(key: UD_CategoryName)
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
}
