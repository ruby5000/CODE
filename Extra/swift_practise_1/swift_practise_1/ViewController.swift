import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 1
    func sumOf_Int ( _ value1:Int, value2:Int) -> Int {
        var ans = 0
        ans = value1 + value2
        if value1 == value2 {
            ans = ans * 3
        }
        return ans
    }
    
    // 2
    func find_diffrence( _ value1:Int) -> Int {
        var ans = 0
        if value1 < 51 {
            ans = 51 - value1
            return ans
        } else if value1 > 51 {
            ans = (value1 - 51) * 2
            return ans
        }
        return 0
    }
    
    // 3
    func sumIs20_is20( _ value1:Int, value2:Int) -> Bool {
        if value1 == 20 || value2 == 20 {
            return true
        } else if (value1 + value2) == 20 {
            return true
        }
        return false
    }
    
    // 4
    func check_positive_negetive( _ value1:Int, value2:Int) -> Bool {
        if value1 > 0 || value2 < 0 {
            return true
        } else if value1 < 0 || value2 < 0 {
            return true
        } else {
            return false
        }
    }
    
    // 5
    func add_string( _ name:String) -> String {
        let ans = "is" + " " + name
        if name.hasPrefix("is") == true {
            return name
        }
        return ans
    }
    
    // 7
    func first_last_swap( _ name:String) -> String {
        var ans = name
        let first = ans.remove(at: ans.startIndex)
        let first_value = first
        let last = ans.index(before: ans.endIndex)
        let last_value = ans.remove(at: last)
        return "\(last_value)" + ans + "\(first_value)"
    }
    
    // 8
    func add_fist_last_char( _ name:String) -> String { // SWIFT -> TSWIFTT
        var ans = name
        let last_char = ans.removeLast()
        return "\(last_char)" + ans + "\(last_char)" + "\(last_char)"
    }
    
    // 9
    func check_multipleOf_3And5( _ value:Int) -> Bool {
        if value > 0 {
            if (value % 3 == 0) || (value % 5 == 0) {
                return true
            }
        }
        return false
    }
    
    // 10
    func newString_first_last( _ name:String) -> String { // SWIFT
        var ans = name
        var temp = ""
        let newStr = ""
        let first_char = ans.remove(at: ans.startIndex)
        temp.append(ans)
        let second_char = ans.remove(at: ans.startIndex)
        return "\(first_char)" + "\(second_char)" + newStr + "\(first_char)" + "\(second_char)"
    }
    
    // 11
    func checkString_IS( _ name:String) -> Bool {
        if name.hasPrefix("is") == true {
            return true
        }
        return false
    }
    
    // 12
    func checkValueis_inRange( _ value:Int) -> Bool {
        switch value {
        case 10...30:
            return true
        default:
            return false
        }
    }
    
    // 13
    func checkString( _ name:String) -> Bool {
        if name.hasPrefix("fix") == true {
            return true
        }
        return false
    }
    
    // 14
    func large_number( _ value1:Int, _ value2:Int, _ value3:Int) -> Int { // 50 12 20
        if (value1 > value2), (value1 > value3) {
            return value1
        } else if (value2 > value1), (value2 > value3) {
            return value2
        } else if (value3 > value1), (value3 > value2) {
            return value3
        }
        return 0
    }
    
    // 15
    func valueNearTo10( _ value1:Int, _ value2:Int) -> Int {
        if (value1 > 10) && (value2 > 10) {
            return 0
        }
        if (value1 - 10) > (value2 - 10) {
            return value1
        } else {
            return value2
        }
    }
    
    // 16
    func isValue_inRange( _ value1:Int, _ value2:Int) -> Bool {
        if value1 > 20 && value1 < 30 && value2 > 30 && value2 < 40 {
            return true
        } else if value1 > 30 && value1 < 40 && value2 > 30 && value2 < 40  {
            return true
        }  else {
            return false
        }
    }
    
    // 17
    func checkValue_inRange( _ value1:Int, _ value2:Int) -> Bool {
        var large = 0
        if value1 > value2 {
            large = large + value1
        } else if value2 > value1 {
            large = large + value2
        }
        switch large {
        case 20...30:
            return true
        default:
            return false
        }
    }
    
    // 18
    func checkvalueis_sameOrnot( _ value1:Int, _ value2:Int) -> Bool {
        if (value1 < 0) && (value2 < 0) {
            return false
        }
        let value1_last_digit = value1.words.last!
        let value2_last_digit = value2.words.last!
        if value1_last_digit == value2_last_digit {
            return true
        } else {
            return false
        }
    }
    
    // 19
    func convertIn_Uppercase( _ name:String) -> String {
        var ans = name
        var newStr = ""
        if name.count <= 3 {
            return name.lowercased()
        }
        let last_char = ans.removeLast()
        let last2_char = ans.removeLast()
        let last3_char = ans.removeLast()
        
        newStr = "\(last3_char.uppercased())" + "\(last2_char.uppercased())" + "\(last_char.uppercased())"
        ans.append(newStr)
        return ans
    }
    
    // 22
    func count7( _ arr:[Int]) -> Int {
        var count = 0
        for i in 0..<arr.count {
            if arr[i] == 7 {
                count = count + 1
            }
        }
        return count
    }
    
    // 23
    func checkNum_is7( _ arr:[Int]) -> Bool {
        for i in 0..<arr.count {
            if arr[i] == 7 {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    // 24
    func find_squence( _ arr:[Int]) -> Bool {
        for i in 0..<arr.count-2 {
            if (arr[i] == arr[i+1] - 1) && (arr[i+1] == arr[i+2] - 1) {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    // 27
    func check7is_nextTonext( _ arr:[Int]) ->  Bool {
        for i in 0..<arr.count {
            if arr[i] == 7 || arr[i+1] == 7 {
                return true
            } else {
                return false
            }
        }
        return false
    }
}
