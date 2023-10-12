import UIKit
import Lottie

class WelcomeVC: UIViewController {

    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLotties()
    }
    
    @IBAction func btnTap_login(_ sender: UIButton) {
        let vc = MainstoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTap_signup(_ sender: UIButton) {
        let vc = MainstoryBoard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setLotties() {
        animationView = .init(name: "lotties")
        animationView!.frame = view.alignmentRect(forFrame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width - 40, height: 300))
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .repeatBackwards(10)
        animationView!.animationSpeed = 1
        view.addSubview(animationView!)
        animationView!.play()
    }
}
