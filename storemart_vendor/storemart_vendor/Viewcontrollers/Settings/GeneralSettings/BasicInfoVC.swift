import UIKit

class BasicInfoVC: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func btnAction_selectDelivery(_ sender: UIButton) {
  }
}
