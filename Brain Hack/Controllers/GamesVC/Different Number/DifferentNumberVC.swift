import UIKit

class DifferentNumberVC: UIViewController {
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    
    var gameScore = 0
    var randomeNo = 124
    var randomeBtn = 10
    var checkArray = ""
    var arrryColor : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    @IBAction func btnTap_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DifferentNumberVC {
    func setUpData(){
        randomeNo = Int.random(in: 101...444)
        
        arrryColor.removeAll()
        arrryColor.append(getFinalAns())
        arrryColor.append(getFinalAns())
        arrryColor.append(getFinalAns())
        arrryColor.append(getFinalAns())
        
        checkArray = "\(arrryColor[0]), \(arrryColor[1]), \(arrryColor[2]), \(arrryColor[3])"
        
        arrryColor.append(randomeNo)
        
        arrryColor = arrryColor.shuffled()
        
        let actionYes: () -> Void = {
            
        }
                self.showCustomAlertWith(
                    okButtonAction: actionYes, // This is optional
                    message: "Remember this \(checkArray)",
                    itemimage: #imageLiteral(resourceName: "ic_kids"),
                    actions: nil)
        
        oneButton.setTitle("\(arrryColor[0])", for: .normal)
        twoButton.setTitle("\(arrryColor[1])", for: .normal)
        threeButton.setTitle("\(arrryColor[2])", for: .normal)
        fourButton.setTitle("\(arrryColor[3])", for: .normal)
        fiveButton.setTitle("\(arrryColor[4])", for: .normal)
    }
    
    func fire(){
        let actionYes : [String: () -> Void] = [ "Retry" : { (
            self.setUpData()
        ) }]
        
        let actionNo : [String: () -> Void] = [ "Return" : { (
            self.navigationController?.popViewController(animated: true)
        ) }]
        
        let arrayActions = [actionYes, actionNo]
        
                self.showCustomAlertWith(
                    message: "Your game score: \(gameScore), Please try agin!",
                    itemimage: #imageLiteral(resourceName: "ic_kids"),
                    actions: arrayActions)
    }
    
    func getFinalAns() -> (Int) {
        if(Bool.random()){
            return randomeNo + Int.random(in: 1...10)
        }else{
            return randomeNo - Int.random(in: 1...10)
        }
    }
}

extension DifferentNumberVC {
    @IBAction func oneBtnClick(_ sender: UIButton) {
        if  (oneButton.titleLabel?.text == String(randomeNo)){
            self.showToast(backgroundColor: UIColor.green, textColor: UIColor.white, message: NSLocalizedString("Congratulation", comment: ""))
            gameScore += 1
            setUpData()
//               scoreLbl.text = "Your game score: \(gameScore)"
        }else{
            fire()
        }
    }
       
    @IBAction func twoBtnClick(_ sender: UIButton) {
        if  (twoButton.titleLabel?.text == String(randomeNo)){
            self.showToast(backgroundColor: UIColor.green, textColor: UIColor.white, message: NSLocalizedString("Congratulation", comment: ""))
            gameScore += 1
            setUpData()
//            scoreLbl.text = "Your game score: \(gameScore)"
        }else{
            fire()
        }
    }
           
    @IBAction func threeBtnClick(_ sender: UIButton) {
        if  (threeButton.titleLabel?.text == String(randomeNo)){
            self.showToast(backgroundColor: UIColor.green, textColor: UIColor.white, message: NSLocalizedString("Congratulation", comment: ""))
            gameScore += 1
            setUpData()
//               scoreLbl.text = "Your game score: \(gameScore)"
        }else{
            fire()
        }
    }
          
      @IBAction func fourBtnClick(_ sender: UIButton) {
          if  (fourButton.titleLabel?.text == String(randomeNo)){
              self.showToast(backgroundColor: UIColor.green, textColor: UIColor.white, message: NSLocalizedString("Congratulation", comment: ""))
              gameScore += 1
              setUpData()
  //               scoreLbl.text = "Your game score: \(gameScore)"
          }else{
              fire()
          }
      }
        
    @IBAction func fiveBtnClick(_ sender: UIButton) {
        if  (fourButton.titleLabel?.text == String(randomeNo)){
            self.showToast(backgroundColor: UIColor.green, textColor: UIColor.white, message: NSLocalizedString("Congratulation", comment: ""))
            gameScore += 1
            setUpData()
//               scoreLbl.text = "Your game score: \(gameScore)"
        }
        else{
            fire()
        }
    }
}
