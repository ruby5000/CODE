import UIKit

class thirdVC: UIViewController {
    
    @IBOutlet weak var lbl_one: UILabel!
    @IBOutlet weak var lbl_two: UILabel!
    
    var firstValue = ""
    var secondValue = ""
    weak var delegate: SecondProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_one.text! = firstValue
        self.lbl_two.text! = secondValue
    }
    
    @IBAction func btnTap_next(_ sender: UIButton) {
        let objVc = firstVC()
        objVc.delegate = self
        delegate?.secondFunction(data: self.lbl_one.text!, data2: self.lbl_two.text!)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension thirdVC: FirstProtocol {
    func firstFunction(data: String, data2: String) {
        print(data)
        print(data2)
    }
}
