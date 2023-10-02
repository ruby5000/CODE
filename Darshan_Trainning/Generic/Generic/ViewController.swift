import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // allows us to create a single function and class that can be used with different data types.
        
        func displayData<T:Numeric>(data1:T, data2:T) {
            print(data1+data2)
        }
        displayData(data1: 5, data2: 5.5)
        let intValue = getData<Int>(dataValue: 1)
        let stringValue = getData<String>(dataValue: "1")
        print(intValue.printDataValue())
        print(stringValue.printDataValue())
    }
}

class getData<T> {
    var dataValue : T
    init(dataValue: T) {
        self.dataValue = dataValue
    }
    func printDataValue() -> T {
        return self.dataValue
    }
}


// MARK: - ARC
// Automatic Reference Counting
// track and manage app's memory usage
// reference counting apply only instance of Class
// A strong reference is the default, for variables, properties, constants, passing into functions and for closures.
// A weak reference is a reference that doesn’t keep a strong hold on the instance
