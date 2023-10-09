import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let b = Aclass()
        b.numbers()
    }
}

protocol Aprotocol{
    var a: String { get }
    func numbers()
}

class Aclass: Aprotocol {
    func numbers() {
        print(a)
    }
    var a = "hello"
}
