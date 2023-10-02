import UIKit

class InvoiceVC: UIViewController {

  @IBOutlet weak var tableview_items_invoice: UITableView!
  @IBOutlet weak var height_tableview_items_invoice: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableview_items_invoice.reloadData()
    self.tableview_items_invoice.delegate = self
    self.tableview_items_invoice.dataSource = self
    self.height_tableview_items_invoice.constant = CGFloat(3*90)
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
}


extension InvoiceVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell") as! itemsCell
    return cell
  }
}
