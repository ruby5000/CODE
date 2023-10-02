import UIKit

class transactionCell: UITableViewCell{

}

class TransactionVC: UIViewController {

  @IBOutlet weak var tableview_transaction: UITableView!
  @IBOutlet weak var height_tableview_transaction: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
      self.tableview_transaction.reloadData()
      self.tableview_transaction.delegate = self
      self.tableview_transaction.dataSource = self
      self.height_tableview_transaction.constant = CGFloat(8*100)
    }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
}


extension TransactionVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as! transactionCell
    return cell
  }
}
