import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        for i in 0...4 {
        //            for j in 0...i {
        //                print("*", terminator: " ")
        //            }
        //            print("\n")
        //        }
        
        for i in 1...5 {
            for j in 0..<i {
                print(j, terminator: " ")
            }
            print("\n")
        }
    }
}
