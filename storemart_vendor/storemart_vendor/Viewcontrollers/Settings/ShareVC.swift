import UIKit

class ShareVC: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
}
