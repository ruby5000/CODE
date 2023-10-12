import UIKit

class ImageRememberVC: UIViewController {

    @IBOutlet var btnColl: [UIButton]!
    @IBOutlet var queLbl: UILabel!
    
    var arrayImageName : [Int]! = []
    var arrayTempName : [Int]! = []
    var finalAns = UIImage.init(named: "ic_object")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...51 {
            arrayImageName.append(i)
        }
        setupImage()
    }
    
    @IBAction func btnTap_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnImage1(_ sender: UIButton) {
        checkAns(ansNumber: sender.currentImage!)
    }
    @IBAction func btnImage2(_ sender: UIButton) {
        checkAns(ansNumber: sender.currentImage!)
    }
    @IBAction func btnImage3(_ sender: UIButton) {
        checkAns(ansNumber: sender.currentImage!)
    }
    @IBAction func btnImage4(_ sender: UIButton) {
        checkAns(ansNumber: sender.currentImage!)
    }
    @IBAction func btnImage5(_ sender: UIButton) {
        checkAns(ansNumber: sender.currentImage!)
    }
    @IBAction func btnImage6(_ sender: UIButton) {
        checkAns(ansNumber: sender.currentImage!)
    }
    @IBAction func btnImage7(_ sender: UIButton) {
        checkAns(ansNumber: sender.currentImage!)
    }
    @IBAction func btnImage8(_ sender: UIButton) {
        checkAns(ansNumber: sender.currentImage!)
    }
    @IBAction func btnImage9(_ sender: UIButton) {
        checkAns(ansNumber: sender.currentImage!)
    }
    
}

extension ImageRememberVC {
    func setupImage() {

        arrayTempName.removeAll()
        
        arrayImageName = arrayImageName.shuffled()
        
        for i in 0...8{
            arrayTempName.append(arrayImageName[i])
        }
        
        finalAns = UIImage.init(named: "image_\(arrayTempName.randomElement()!)")
        
        arrayTempName = arrayTempName.shuffled()

        for i in 0..<btnColl.count{
            UIView.transition(with: btnColl[i],duration: 0.75,options: .transitionCrossDissolve,animations: {
                self.btnColl[i].setImage(UIImage(named: "image_\(self.arrayTempName[i])"), for: .normal)
            },completion: nil)
        }
        
        let actionYes: () -> Void = {

               }
               self.showCustomAlertWith(
                   okButtonAction: actionYes, // This is optional
                   message: "Remember object",
                   itemimage: finalAns,
                   actions: nil)
               
        
    }
    
    func checkAns(ansNumber : UIImage) {
        if (finalAns == ansNumber){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Change `2.0` to the desired number of seconds.
                self.setupImage()
            }
            self.showToast(backgroundColor: UIColor.green, textColor: UIColor.white, message: NSLocalizedString("Congratulation", comment: ""))
        }else{
            shakeView()
            self.showToast(backgroundColor: UIColor.red, textColor: UIColor.white, message: NSLocalizedString("Please Try agin!", comment: ""))
        }
    }
    func shakeView() {
        btnColl[0].shake()
        btnColl[1].shake()
        btnColl[2].shake()
        btnColl[3].shake()
        btnColl[4].shake()
        btnColl[5].shake()
        btnColl[6].shake()
        btnColl[7].shake()
        btnColl[8].shake()
    }
}
