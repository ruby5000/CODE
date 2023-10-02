
import UIKit

class setting: UIViewController {

    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var centerWhiteView: UIView!
    @IBOutlet weak var soundFX: UISlider!
    @IBOutlet weak var music: UISlider!
    @IBOutlet weak var fx: UILabel!
    @IBOutlet weak var muSic: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blueView.layer.cornerRadius = 15
        blueView.layer.masksToBounds = true
        centerWhiteView.layer.cornerRadius = 8
        centerWhiteView.layer.masksToBounds = true
    }
    @IBAction func sound(_ sender: UISlider) {
        fx.text = String(Int(sender.value))
    }
    @IBAction func music(_ sender: UISlider) {
        muSic.text = String(Int(sender.value))
    }
}

