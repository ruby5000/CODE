import UIKit

class paymentCell: UITableViewCell{
  @IBOutlet weak var btn_edit: UIButton!
}

class PaymentVC: UIViewController {

  @IBOutlet weak var tableview_payments: UITableView!
  @IBOutlet weak var height_tableview_payments: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
      self.tableview_payments.reloadData()
      self.tableview_payments.delegate = self
      self.tableview_payments.dataSource = self
      self.height_tableview_payments.constant = CGFloat(8*105)
    }
  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
}


extension PaymentVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 105
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell") as! paymentCell
    if indexPath.row == 0 {
      cell.btn_edit.isHidden = true
    }
    return cell
  }
}
