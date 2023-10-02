import UIKit

class itemsCell: UITableViewCell {
  
}

class OrderDetailsVC: UIViewController {

  @IBOutlet weak var tableview_items: UITableView!
  @IBOutlet weak var height_tableview_items: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableview_items.reloadData()
    self.tableview_items.delegate = self
    self.tableview_items.dataSource = self
    self.height_tableview_items.constant = CGFloat(3*100)
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func btnTap_Invoice(_ sender: UIButton) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "InvoiceVC") as! InvoiceVC
    self.navigationController?.pushViewController(objVC, animated: true)
  }
}


extension OrderDetailsVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell") as! itemsCell
    return cell
  }
}
