import UIKit

protocol SecondProtocol: AnyObject {
    func secondFunction(data: String,data2:String)
}

class secondVC: UIViewController {
    
    @IBOutlet weak var txt_fisrtTextfield: UITextField!
    @IBOutlet weak var txt_secondTextfield: UITextField!
    
    weak var delegate: FirstProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func secondFunction(data: String) {
        delegate?.firstFunction(data: self.txt_fisrtTextfield.text!, data2: self.txt_secondTextfield.text!)
    }
    
    @IBAction func btnTap_next(_ sender: UIButton) {
        let thirdVC = self.storyboard!.instantiateViewController(withIdentifier: "thirdVC") as! thirdVC
        thirdVC.firstValue = self.txt_fisrtTextfield.text!
        thirdVC.secondValue = self.txt_secondTextfield.text!
        thirdVC.delegate = self
        self.navigationController?.pushViewController(thirdVC, animated: true)
    }
}

extension secondVC: SecondProtocol {
    func secondFunction(data: String, data2: String) {
        delegate?.firstFunction(data: data, data2: data2)
    }
    
    func firstFunction(data: String, data2: String) {
        self.txt_fisrtTextfield.text! = data
        self.txt_secondTextfield.text! = data2
    }
}
