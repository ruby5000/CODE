import UIKit

class SocialAccountsVC: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
}
