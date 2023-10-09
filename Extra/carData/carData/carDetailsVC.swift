import UIKit

class carDetailsVC: UIViewController {

    @IBOutlet weak var img_car: UIImageView!
    @IBOutlet weak var lbl_company: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_mfgYear: UILabel!
    @IBOutlet weak var lbl_color: UILabel!
    
    var indexValue = 0
    var company = ""
    var name = ""
    var price = ""
    var mfgYear = ""
    var color = ""
    var img = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_company.text! = company
        self.lbl_name.text! = name
        self.lbl_price.text! = price
        self.lbl_mfgYear.text! = mfgYear
        self.lbl_color.text! = color
        self.img_car.image! = img
    }
    
    @IBAction func btnTap_submit(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
