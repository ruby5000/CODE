import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var lbl_firstNAme: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_firstNAme.text! = UserDefaults.standard.string(forKey: "FIRST")!
    }
    
    @IBAction func btnTap_logout(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
