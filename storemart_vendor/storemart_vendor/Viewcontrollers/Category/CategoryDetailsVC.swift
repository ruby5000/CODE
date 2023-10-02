import UIKit

class categoryDetailsCell: UITableViewCell{
  
}

class CategoryDetailsVC: UIViewController {

  @IBOutlet weak var tableview_categoryDetails: UITableView!
  @IBOutlet weak var height_tableview_categoryDetails: NSLayoutConstraint!
  @IBOutlet weak var lbl_HeaderName: UILabel!
  @IBOutlet weak var btn_add: UIButton!
  
  var tempText = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    self.addShadowInBtn()
    self.lbl_HeaderName.text = tempText
    self.tableview_categoryDetails.reloadData()
    self.tableview_categoryDetails.delegate = self
    self.tableview_categoryDetails.dataSource = self
    self.height_tableview_categoryDetails.constant = CGFloat(8*280)
  }

  // MARK: - addShadowInBtn
  func addShadowInBtn() {
    self.btn_add.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
    self.btn_add.layer.shadowOpacity = 0.5
    self.btn_add.layer.shadowRadius = 4.0
    self.btn_add.layer.shadowColor = UIColor.black.cgColor
  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func btnAction_add(_ sender: UIButton) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewProductVC") as! AddNewProductVC
    self.navigationController?.pushViewController(objVC, animated: true)
  }
}

extension CategoryDetailsVC : UITableViewDelegate, UITableViewDataSource {

  // MARK: - heightForRowAt
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 280
  }

  // MARK: - numberOfRowsInSection
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }

  // MARK: - cellForRowAt
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryDetailsCell") as! categoryDetailsCell
    return cell
  }
}
