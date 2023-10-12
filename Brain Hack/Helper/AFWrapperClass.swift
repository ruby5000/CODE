import Foundation
import UIKit

enum mathFunction {
    case Add
    case Subtract
}

class AFWrapperClass : NSObject {
    class func compareStringValue(currentValue:String, limit:Int, toDo : mathFunction) -> String {
        var current : Int = Int(currentValue)!
        if (current <= limit) && (current >= 0) {
            if toDo == .Add {
                if current == limit {
                    return String(current)
                }
                else{
                    current += 1
                    return String(current)
                }
            }
            else {
                if current == 1 {
                    return String(current)
                }
                else {
                    current -= 1
                    return String(current)
                }
            }
        }
        else {
            return String(current)
        }
    }
}
