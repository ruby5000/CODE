import UIKit

class mainScreen: UIViewController {
    @IBOutlet weak var PlayBttoun: UIButton!
    @IBOutlet weak var SettingBttoun: UIButton!
    @IBOutlet weak var QuiteBttoun: UIButton!
        override func viewDidLoad() {
        super.viewDidLoad()
            shadow()
            navigationController?.isNavigationBarHidden = true
}
// MARK: - intialsetup for button
    private func shadow() {
        let arrButton: [UIButton] = [PlayBttoun,SettingBttoun,QuiteBttoun]
        for button in arrButton {
            button.layer.cornerRadius = 5
            button.setTitleColor(UIColor.lightGray, for: .normal)
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowRadius = 4
            button.layer.shadowOpacity = 0.5
            button.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    @IBAction func PlayBttoun(_ sender: UIButton) {
        let storyBoard  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let PlayViewController = storyBoard.instantiateViewController(withIdentifier: "PlayViewController" ) as! PlayViewController
        navigationController?.pushViewController(PlayViewController, animated: true)
    }
    @IBAction func SettingsBttoun(_ sender: UIButton) {
        let storyBoard  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let setting = storyBoard.instantiateViewController(withIdentifier: "setting" ) as! setting
        navigationController?.pushViewController(setting, animated: true)
    }
    @IBAction func QuiteBttoun(_ sender: UIButton) {
        showAlert(title: "Confirm Exit !!!" , message: "Are you sure, You want to exit")
    }
    // MARK: - Show Aelrt
        private func showAlert(title : String,  message: String) {
            let  alrert  : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let  okButton  : UIAlertAction = UIAlertAction(title: "Yes", style: .default) { (_) in exit(0) }
            let cancleButton : UIAlertAction = UIAlertAction(title: "Cancle", style: .destructive) { (_) in }
            alrert.addAction(okButton)
            alrert.addAction(cancleButton)
            present(alrert,animated: true,completion: nil)
        }
}
