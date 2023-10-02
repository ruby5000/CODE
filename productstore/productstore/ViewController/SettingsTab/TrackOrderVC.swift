
import UIKit

class TrackOrderVC: UIViewController {
    
    @IBOutlet weak var img_Circle1: UIImageView!
    @IBOutlet weak var lbl_line1: UILabel!
    @IBOutlet weak var img_Circle2: UIImageView!
    @IBOutlet weak var lbl_line2: UILabel!
    @IBOutlet weak var img_Circle3: UIImageView!
    @IBOutlet weak var lbl_line3: UILabel!
    @IBOutlet weak var lbl_4: UILabel!
    @IBOutlet weak var lbl_3: UILabel!
    @IBOutlet weak var lbl_2: UILabel!
    @IBOutlet weak var lbl_1: UILabel!
    @IBOutlet weak var img_Circle4: UIImageView!
    
    var Status = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_1.text = "Order Confirm"
        self.lbl_2.text = "Delivered"
        self.img_Circle3.isHidden = true
        self.img_Circle4.isHidden = true
        self.lbl_line2.isHidden = true
        self.lbl_line3.isHidden = true
        self.lbl_3.isHidden = true
        self.lbl_4.isHidden = true
        
        if self.Status == "0"
        {
            self.img_Circle1.image = UIImage.init(systemName: "circle.fill")
            self.img_Circle1.tintColor = UIColor.init(named: "White_light")
            self.lbl_line1.backgroundColor = UIColor.init(named: "White_light")
            
            self.img_Circle2.image = UIImage.init(systemName: "circle")
            self.img_Circle2.tintColor = UIColor.init(named: "White_light")
            self.lbl_line2.backgroundColor = UIColor.init(named: "White_light")
            
            self.img_Circle3.image = UIImage.init(systemName: "circle")
            self.img_Circle3.tintColor = UIColor.gray
            self.lbl_line3.backgroundColor = UIColor.gray
            
            self.img_Circle4.image = UIImage.init(systemName: "circle")
            self.img_Circle4.tintColor = UIColor.gray
            
        }
        else if self.Status == "1"
        {
            
            self.img_Circle1.image = UIImage.init(systemName: "circle.fill")
            self.img_Circle1.tintColor = UIColor.init(named: "White_light")
            self.lbl_line1.backgroundColor = UIColor.init(named: "White_light")
            
            self.img_Circle2.image = UIImage.init(systemName: "circle.fill")
            self.img_Circle2.tintColor = UIColor.init(named: "White_light")
            self.lbl_line2.backgroundColor = UIColor.init(named: "White_light")
            
        }
        
    }
}
//MARK: Button Action
extension TrackOrderVC
{
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
