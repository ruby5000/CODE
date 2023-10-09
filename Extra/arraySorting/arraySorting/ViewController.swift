import UIKit

class ViewController: UIViewController {

    var arrNum = [3,10,6,7,4,9,1,8,2,5,]
    var value = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<arrNum.count {
            for j in 0..<arrNum.count {
                if arrNum[i] < arrNum[j] {
                    value = arrNum[i]
                    arrNum[i] = arrNum[j]
                    arrNum[j] = value
                }
            }
        }
        print(arrNum)
    }
}
