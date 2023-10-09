import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Overloading
        // two or more functions may have the same name if they different in parameters
        // it increases code readability and maintainability
        // Overloading occurs when two or more methods in the same class have the same name but different parameters
        
        func displayValue(number:Int) -> String {
            return "0"
        }
        func displayValue(number:Int) {
        }
        func displayValue(number:String) {
        }
        
        // MARK: - overriding
        // means having two methods with the same method name and parameters
        // One of the methods is in the parent class and the other is in the child class.
        // Overriding occurs when the method signature is the same in the superclass and the child class.
        
        class first {
            var abc = "0"
            func numbersValue() {
                print("0")
            }
        }
        class second : first {
            //override var abc: String = "100"
            override func numbersValue() {
                print("100")
            }
        }
        let a = second()
        a.numbersValue()
        
        // MARK: - Optional Chaining
        // Access members of an optional value without unwrapping.
        
        class optionals {
            var carValue : values?
        }
        class values {
            var carValues = "10"
        }
        let b = optionals()
        print("\(b.carValue?.carValues)") // without unwarping an optional carValue is nill
        
        // MARK: - Error Handling
        // responds to and recover from error
        // the process of responding to and recovering from error conditions in your program.
        // use of do catch statement
        
        func someThrowingFunction() throws -> Int {
            return 0
        }
        let x = try? someThrowingFunction()
        let y: Int?
        do {
            y = try someThrowingFunction()
        } catch {
            y = nil
        }
        
        // MARK: - Concurrency
        // means that an application is making progress on more than one task at the same time
        // Perform asynchronous operations.
        // actor is likely to close class,but not support inheritance and other access modifier which class have
        actor User {
            var name: String
            init(name:String){
                self.name = name
            }
        }
    }
}
