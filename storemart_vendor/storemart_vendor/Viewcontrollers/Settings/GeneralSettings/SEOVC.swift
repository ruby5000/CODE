import UIKit

class SEOVC: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
}
