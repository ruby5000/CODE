import UIKit

// MARK: - Protocol
// a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality.

class firstClass: secondClass,firstProtocol,thirdProtocol{
    
    required init(value: Int) { }
    var a: Int = 1
    var b: String = "2"
}
class secondClass{
    init() { }
}

protocol firstProtocol { // stored property
    var a: Int { get set }
    var b: String { get }
}
protocol secondProtocol { // type property
    static var c: Int { get }
}
protocol thirdProtocol { // init requirement
    init(value:Int)
}

protocol inHeritance: secondProtocol { } //protocol inheritance

extension firstClass: secondProtocol {
    static var c: Int = 3
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


class Master {
    var value: Int
    init(value: Int) {
        self.value = 0
    }
    class Nested {
        var value2: Int
        init(value2: Int) {
            self.value2 = 1
        }
    }
}
