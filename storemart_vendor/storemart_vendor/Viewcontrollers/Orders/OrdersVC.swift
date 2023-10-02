import UIKit

class OrdersCell: UITableViewCell {

}

class OrdersVC: UIViewController {

  @IBOutlet weak var tableview_orders: UITableView!
  @IBOutlet weak var height_tableview_orders: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableview_orders.reloadData()
    self.tableview_orders.delegate = self
    self.tableview_orders.dataSource = self
    self.height_tableview_orders.constant = CGFloat(8*130)
  }
}


extension OrdersVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 130
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell") as! OrdersCell
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
    self.navigationController?.pushViewController(objVC, animated: true)
  }
}
