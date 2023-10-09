import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - inheritance
        
        // one class can access to another class
        class Inheritance1 {
            var value : Int = 0
            func currentValue() {
            }
        }
        let temp = Inheritance1()
        temp.value = 0
        
        class Inheritance2: Inheritance1 {
            var number : Int = 0
        }
        let temp2 = Inheritance2()
        temp2.value = 50

        class OverRide: Inheritance1 {
            override func currentValue() {
                //print("5")
            }
        }
        let temp3 = OverRide()
        temp3.value = 55
        temp3.currentValue()
        
        // MARK: - Initialization
        // is the process of preparing an instance of a class, structure, or enumeration for use.
        
        class Initializers {
            var initValue : Int = 0
            init(value: Int) {
                initValue = 5 + value
            }
        }
        let f = Initializers(value: 25)
        print("\(f.initValue)")
        
        class Numbers {
            var carValue : Int
            var carName : String?
            init(carValue: Int, carName: String? = nil) {  // Designated init
                self.carValue = carValue
                self.carName = carName
            }
            convenience init() {  // convenience init
                self.init(carValue: 500)
            }
            func Print() {
                print(carValue)
            }
        }
        let a = Numbers()
        a.Print()
        // allow you to initialise a class without all the required parameters the designated initialiser needs
        
        // failable initializers
        // optional init
        
        class OptionalInit {
            let numValue : String
            init?(numValue: String) {
                if numValue.isEmpty {return nil}
                self.numValue = numValue
            }
        }
        
        // MARK: - Dinitializers
        // called immediately before a class instance is deallocated
        class Bank {
            static var coinsInBank = 10
            static func distribute(coins numberOfCoinsRequested: Int) -> Int {
                return 50
            }
            static func receive(coins: Int) {
                coinsInBank += coins
            }
        }
        
        class Player {
            var coinsInPurse: Int
            init(coins: Int) {
                coinsInPurse = Bank.distribute(coins: coins)
            }
            func win(coins: Int) {
                coinsInPurse += Bank.distribute(coins: coins)
            }
            deinit {
                Bank.receive(coins: coinsInPurse)
            }
        }
        let result : Player? = Player(coins: 80)
        print(result!)
    }
}
