import UIKit

struct SubjectMarks {
    var sub1: String
    var sub2: String
    var sub3: String
    var sub4: String
    var sub5: String
}

class markVC: UIViewController {
    
    @IBOutlet weak var txt_sub1: UITextField!
    @IBOutlet weak var txt_sub2: UITextField!
    @IBOutlet weak var txt_sub3: UITextField!
    @IBOutlet weak var txt_sub4: UITextField!
    @IBOutlet weak var txt_sub5: UITextField!
    
    var arrSubMarks = [SubjectMarks]()
    var subTotal = 0
    var subPercentage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.txt_sub1.text! = ""
        self.txt_sub2.text! = ""
        self.txt_sub3.text! = ""
        self.txt_sub4.text! = ""
        self.txt_sub5.text! = ""
    }
    
    @IBAction func btnTap_submit(_ sender: UIButton) {
        self.arrSubMarks.append(SubjectMarks(sub1: self.txt_sub1.text!,
                                             sub2: self.txt_sub2.text!,
                                             sub3: self.txt_sub3.text!,
                                             sub4: self.txt_sub4.text!,
                                             sub5: self.txt_sub5.text!))
        
        let objVC = self.storyboard!.instantiateViewController(withIdentifier: "resultVC") as! resultVC
        subTotal = Int(self.txt_sub1.text!)! + Int(self.txt_sub2.text!)! + Int(self.txt_sub3.text!)! + Int(self.txt_sub4.text!)! + Int(self.txt_sub5.text!)!
        
        if Int(self.txt_sub1.text!)! < 40 || Int(self.txt_sub2.text!)! < 40 || Int(self.txt_sub3.text!)! < 40 || Int(self.txt_sub4.text!)! < 40 || Int(self.txt_sub5.text!)! < 40 {
            objVC.resultMsg = "Sorry!! you are Fail"
        } else {
            objVC.resultMsg = "Congratulations you are Pass"
        }
        
        //        switch  {
        //        case :
        //            <#code#>
        //        default:
        //            <#code#>
        //        }
        
        print(subTotal)
        objVC.subTotal = subTotal
        objVC.arrSubjectTotal = self.arrSubMarks
        navigationController?.pushViewController(objVC, animated: true)
    }
}
