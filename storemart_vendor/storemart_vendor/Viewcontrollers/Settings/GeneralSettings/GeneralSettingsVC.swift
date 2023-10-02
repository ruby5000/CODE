import UIKit

class generalSettingsCell: UITableViewCell{
  @IBOutlet weak var lbl_title: UILabel!
}

class GeneralSettingsVC: UIViewController {

  @IBOutlet weak var tableview_generalSettings: UITableView!
  @IBOutlet weak var height_tableview_generalSettings: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableview_generalSettings.reloadData()
    self.tableview_generalSettings.delegate = self
    self.tableview_generalSettings.dataSource = self
    self.height_tableview_generalSettings.constant = CGFloat(4*70)
  }
  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
}


extension GeneralSettingsVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "generalSettingsCell") as! generalSettingsCell
    if indexPath.row == 0 {
      cell.lbl_title.text = "Basic info"
    }
    else if indexPath.row == 1 {
      cell.lbl_title.text = "Theme settings"
    }
    else if indexPath.row == 2 {
      cell.lbl_title.text = "SEO"
    }
    else if indexPath.row == 3 {
      cell.lbl_title.text = "Social accounts"
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "BasicInfoVC") as! BasicInfoVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 1 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ThemeSettingVC") as! ThemeSettingVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 2 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "SEOVC") as! SEOVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 3 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialAccountsVC") as! SocialAccountsVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }
  }
}
