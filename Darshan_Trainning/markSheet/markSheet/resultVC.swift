import UIKit

class resultVC: UIViewController {

    @IBOutlet weak var lbl_resultMsg: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_percentage: UILabel!
    @IBOutlet weak var lbl_class: UILabel!
    
    var arrSubjectTotal = [SubjectMarks]()
    var subTotal = 0
    var subPercentage = 0.0
    var resultMsg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_total.text = String(subTotal)
        subPercentage = Double((Float(subTotal) / 500) * 100)
        self.lbl_percentage.text = String(subPercentage)+"%"
        self.lbl_resultMsg.text = resultMsg
        print(subPercentage)
        
        switch subPercentage {
        case 70.0...100.0:
            self.lbl_class.text! = "Distinction"
        case 60.0...70.0:
            self.lbl_class.text! = "First Class"
        case 50.0...60.0:
            self.lbl_class.text! = "Second Class"
        case 0.00...50.0:
            self.lbl_class.text! = "Pass Class"
        default:
            self.lbl_class.text! = "Error"
        }
    }

    @IBAction func btnTap_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
