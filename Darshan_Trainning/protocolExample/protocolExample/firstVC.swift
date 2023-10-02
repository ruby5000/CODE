import UIKit

protocol FirstProtocol: AnyObject {
    func firstFunction(data: String,data2:String)
}
class firstVC: UIViewController,FirstProtocol,SecondProtocol {
    func secondFunction(data: String, data2: String) {
        print(data)
        print(data2)
    }
    func firstFunction(data: String, data2: String) {
        self.lbl_one.text! = data
        self.lbl_two.text! = data2
    }
    
    @IBOutlet weak var lbl_one: UILabel!
    @IBOutlet weak var lbl_two: UILabel!
    
    weak var delegate: FirstProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnTap_next(_ sender: UIButton) {
        let objCV = self.storyboard!.instantiateViewController(withIdentifier: "secondVC") as! secondVC
        self.navigationController?.pushViewController(objCV, animated: true)
        objCV.delegate = self
    }
}
