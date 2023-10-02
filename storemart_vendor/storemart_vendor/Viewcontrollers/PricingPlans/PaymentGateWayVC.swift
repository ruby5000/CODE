import UIKit

class paymentGatewayCell : UITableViewCell {

}

class PaymentGateWayVC: UIViewController {

  @IBOutlet weak var tableview_pricingGateWay: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableview_pricingGateWay.reloadData()
    self.tableview_pricingGateWay.delegate = self
    self.tableview_pricingGateWay.dataSource = self
  }
  
  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
}


extension PaymentGateWayVC : UITableViewDelegate, UITableViewDataSource{

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "paymentGatewayCell") as! paymentGatewayCell
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .none
  }
}
