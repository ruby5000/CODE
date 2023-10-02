import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var startButtoun: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        startButtoun.layer.cornerRadius = 5
        startButtoun.setTitleColor(UIColor.black, for: .normal)
        startButtoun.layer.shadowColor = UIColor.lightGray.cgColor
        startButtoun.layer.shadowRadius = 4
        startButtoun.layer.shadowOpacity = 1
        startButtoun.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    @IBAction func startButtoun(_ sender: UIButton) {
        showAlert( )
    }
    @IBAction func backButton(_ sender: UIButton) {
        let storyBoard  : UIStoryboard = UIStoryboard(name: "mainScreen", bundle: nil)
        let mainScreen = storyBoard.instantiateViewController(withIdentifier: "mainScreen" ) as! mainScreen
        navigationController?.pushViewController(mainScreen, animated: true)
    }
    // MARK: - ShowAlert
    private func showAlert() {
        let  alrert  : UIAlertController = UIAlertController(title: "Rules", message: "1. there will be 9 color tiles.\n 2. A player has to pick any color tile with greater number of same color tile.", preferredStyle: .alert)
        let  okButton  : UIAlertAction = UIAlertAction(title: "Ok", style: .default) {  (_) in
            self.level()
        }
        let cancleButton : UIAlertAction = UIAlertAction(title: "Cancle", style: .destructive) { (_) in
        }
        alrert.addAction(okButton)
        alrert.addAction(cancleButton)
        present(alrert,animated: true,completion: nil)
    }
// MARK: - Nevigation function
    private func level() {
        let storyBoard  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let level = storyBoard.instantiateViewController(withIdentifier: "level" ) as! level
        navigationController?.pushViewController(level, animated: true)
    }
}
