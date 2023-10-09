import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Closures
        // Group code that executes together, without creating a named function.
        
        // without parameter and return
        let closures = {print("swift closures")}
        closures()
        
        // with return without parameter
        let addition = {() -> Int in
            return 10+20
        }
        print(addition())
        
        // with parameter without return
        let paraMeterOnly = {(num:Int) in
            print(num)
        }
        paraMeterOnly(5)
        
        // with parameter and return
        let withreturn = {(string:String) -> String in
            return (string)
        }
        print (withreturn("SWIFT"))
        
        // trailling closures
        func trailingClosures (closures: () -> Void) {
            
        }
        
        // MARK: - Property
        // associated value that are stored in class instance
        
        // Stored Property
        // Stored properties are properties that are stored in the class or struct
        struct Numbers {
            var one : Int
            let two : Int
        }
        let result = Numbers(one: 1, two: 2)
        print(result)
        
        // Computed Property
        // Computed properties are for creating custom get and set methods for stored properties.
        class Heights {
            var one = 0
            var two = 0
        }
        class Width {
            var three = 0
            var four = 0
        }
        class Result {
            var rect1 = Heights()
            var rect2 = Width()
            var count : Heights {
                get {
                    return Heights()
                }
                // optional
                set {
                    
                }
            }
        }
        
        // MARK: - Methods
        // methods are functions that are associated with a particular type.
        
        // Instance methods
        // Instance methods are functions that belong to instances of a particular class, structure, or enumeration.
        
        class InstanceMethod {
             var count = 0
             func instanceFunction() {
                
            }
        }
        InstanceMethod().count = 1
        InstanceMethod().instanceFunction()
        
        // Type TypeMethod
        // is associated with a class and not with an instance
        class TypeMethod {
            class func typeFunction() {
                
            }
        }
        TypeMethod.typeFunction()
        
        // MARK: - Subscripts
        // used as a shortcut for accessing the member elements in a collection, list, or sequence.
    }
}
