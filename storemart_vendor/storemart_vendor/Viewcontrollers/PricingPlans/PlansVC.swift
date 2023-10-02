import UIKit

class PlansVC: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
  
  @IBAction func btnTap_buyNow(_ sender: Any) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentGateWayVC") as! PaymentGateWayVC
    self.navigationController?.pushViewController(objVC, animated: true)
  }
}
