import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // common type for a group of related values.
        
        enum enumExample: CaseIterable {
            case one,two,three
            case four
            case five
        }
        
        let a = enumExample.allCases.count
        print(a)
        
        for i in enumExample.allCases {
            print(i)
        }
    }
}
