import UIKit

class cellSetting : UITableViewCell {
  @IBOutlet weak var img_icon: UIImageView!
  @IBOutlet weak var lbl_name: UILabel!
}

class SettingVC: UIViewController {

  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var emailId: UILabel!
  @IBOutlet weak var tableview_setting: UITableView!
  @IBOutlet weak var height_tableview: NSLayoutConstraint!
  @IBOutlet weak var img_profileImage: UIImageView!

  var arrIcon = [String]()
  var arrName = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func btnTap_edit(_ sender: UIButton) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
    self.navigationController?.pushViewController(objVC, animated: true)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "N/A" {
      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      let objVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
      let nav : UINavigationController = UINavigationController(rootViewController: objVC)
      nav.navigationBar.isHidden = true
      keyWindow?.rootViewController = nav
    }
    else {
      if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" {
        self.arrIcon = ["ic_1","ic_2","ic_3","ic_4","ic_5","ic_6","ic_7","ic_8","ic_10"]
        self.arrName = ["Change password","Delivery Area","Working Hours","Payments","Coupons","Transactions","General Settings","Share","Login"]
      } else {
        self.arrIcon = ["ic_1","ic_2","ic_3","ic_4","ic_5","ic_6","ic_7","ic_8","ic_9"]
        self.arrName = ["Change password","Delivery Area","Working Hours","Payments","Coupons","Transactions","General Settings","Share","Logout"]
      }
      self.tableview_setting.reloadData()
      self.tableview_setting.delegate = self
      self.tableview_setting.dataSource = self
      self.height_tableview.constant = CGFloat(self.arrIcon.count*50)
      self.name.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userFullname)
      self.emailId.text = UserDefaultManager.getStringFromUserDefaults(key: UD_emailId)
    }
  }
}

extension SettingVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.arrIcon.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellSetting") as! cellSetting
    cell.img_icon.image = UIImage(named: self.arrIcon[indexPath.row])
    cell.lbl_name.text = self.arrName[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 1 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryAreaVC") as! DeliveryAreaVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 2 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WorkingHoursVC") as! WorkingHoursVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 3 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 4 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "CouponsVC") as! CouponsVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 5 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionVC") as! TransactionVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 6 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "GeneralSettingsVC") as! GeneralSettingsVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 7 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 8 {
      let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "Are you sure to logout from this app?", preferredStyle: .alert)
      let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(objVC, animated: true)
      }
      let noAction = UIAlertAction(title: "No", style: .destructive)
      alertVC.addAction(noAction)
      alertVC.addAction(yesAction)
      self.present(alertVC,animated: true,completion: nil)
    }
  }
}
