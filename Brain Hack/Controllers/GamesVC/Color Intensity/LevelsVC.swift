import UIKit

class LevelsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnTap_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTap_Beginner(_ sender: UIButton) {
        nevigationToGame (mode: "Easy")
    }
    
    @IBAction func btnTap_Intermediate(_ sender: UIButton) {
        nevigationToGame (mode: "Medium")
    }
    
    @IBAction func btnTap_Advanced(_ sender: UIButton) {
        nevigationToGame (mode: "Hard")
    }
}

extension LevelsVC {
    func nevigationToGame (mode: String) {
        let vc  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gamePlays = vc.instantiateViewController(withIdentifier: "ColorIntensityVC" ) as! ColorIntensityVC
        gamePlays.strLevel = mode
        navigationController?.pushViewController(gamePlays, animated: true)
    }
}
