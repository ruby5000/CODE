import UIKit
import SDWebImage

class cellSetting : UITableViewCell {
  @IBOutlet weak var img_icon: UIImageView!
  @IBOutlet weak var lbl_name: UILabel!
  @IBOutlet weak var img_ArrowIcon: UIImageView!
  @IBOutlet weak var switch_darkMode: UISwitch!
}

class SettingsVC: UIViewController {

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
        self.arrIcon = ["ic_1","ic_2","ic_3","ic_4","ic_5","ic_6","ic_7","ic_9"]
        self.arrName = ["Change password","Contact Us","Privacy policy","About","Terms And Conditions","Change layout","Dark mode","Login"]
      } else {
        self.arrIcon = ["ic_1","ic_2","ic_3","ic_4","ic_5","ic_6","ic_7","ic_10"]
        self.arrName = ["Change password","Contact Us","Privacy policy","About","Terms And Conditions","Change layout","Dark mode","Logout"]
      }
      self.tableview_setting.reloadData()
      self.tableview_setting.delegate = self
      self.tableview_setting.dataSource = self
      self.height_tableview.constant = CGFloat(self.arrIcon.count*50)

      self.img_profileImage.sd_setImage(with: URL(string: UserDefaultManager.getStringFromUserDefaults(key: UD_Userprofile)), placeholderImage: UIImage(named: "ic_placeholder"))
      self.name.text = UserDefaultManager.getStringFromUserDefaults(key: UD_userFullname)
      self.emailId.text = UserDefaultManager.getStringFromUserDefaults(key: UD_emailId)
    }
  }
}


extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
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
    cell.switch_darkMode.tag = indexPath.row
    cell.switch_darkMode.addTarget(self, action: #selector(switch_Darkmode), for: .touchUpInside)

    if indexPath.row == 0 {
      cell.switch_darkMode.isHidden = true
      cell.img_ArrowIcon.isHidden = false
    }

    if indexPath.row == 1 {
      cell.img_ArrowIcon.isHidden = false
      cell.switch_darkMode.isHidden = true
    }

    if indexPath.row == 2 {
      cell.img_ArrowIcon.isHidden = false
      cell.switch_darkMode.isHidden = true
    }

    if indexPath.row == 3 {
      cell.img_ArrowIcon.isHidden = false
      cell.switch_darkMode.isHidden = true
    }

    if indexPath.row == 4 {
      cell.img_ArrowIcon.isHidden = false
      cell.switch_darkMode.isHidden = true
    }

    if indexPath.row == 5 {
      cell.img_ArrowIcon.isHidden = false
      cell.switch_darkMode.isHidden = true
    }

    if indexPath.row == 6 {
      if cell.switch_darkMode.isOn == true {
        UserDefaultManager.setStringToUserDefaults(value: "1", key: "1")
      }
      cell.switch_darkMode.isHidden = false
      cell.img_ArrowIcon.isHidden = true
    }

    if indexPath.row == 7 {
      cell.img_ArrowIcon.isHidden = false
      cell.switch_darkMode.isHidden = true
    }

    return cell
  }

  @objc func switch_Darkmode(sender:UIButton) {
    let window = UIApplication.shared.windows[0]
    window.overrideUserInterfaceStyle = .dark
  }


  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 1 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 2 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 3 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 4 {
      let objVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
      self.navigationController?.pushViewController(objVC, animated: true)
    }

    if indexPath.row == 5 {
      let alert = UIAlertController(title: Bundle.main.displayName!, message: "Select Application Layout", preferredStyle: .actionSheet)
      let ltr = UIAlertAction(title: "LTR", style: .default) { (action) in
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.navigationController?.pushViewController(objVC, animated: true)
      }
      let rtl = UIAlertAction(title: "RTL", style: .default) { (action) in
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.navigationController?.pushViewController(objVC, animated: true)
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
      alert.addAction(ltr)
      alert.addAction(rtl)
      alert.addAction(cancelAction)
      self.present(alert, animated: true, completion: nil)
    }

    if indexPath.row == 6 {

    }

    if indexPath.row == 7 {
      if UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_userId) == "N/A" {

      } else {
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
}
