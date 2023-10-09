import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(checkAdajcent_number([2,4,5,6]))
    }
    
    // 1
    func first_last_5( _ arr:[Int]) -> Bool {
        if arr.first == 5 || arr.last == 5 {
            return true
        } else {
            return false
        }
    }
    
    // 2
    func equal_num( _ arr:[Int]) -> Bool {
        if arr.first == arr.last {
            return true
        } else {
            return false
        }
    }
    
    // 3
    func first_last( _ arr1:[Int], arr2:[Int]) -> Bool {
        if arr1.first == arr2.first || arr1.last == arr2.last {
            return true
        } else {
            return false
        }
    }
    
    // 4
    func sum_ofarr( _ arr:[Int]) -> Int {
        var sum = 0
        for i in arr {
            sum = sum + i
        }
        return sum
    }
    
    // 5
    func rotat_arr() -> [Int] {
        var arrNumber = [-1,0,1]
        var temp = 0
        temp = arrNumber.first!
        arrNumber.removeFirst()
        arrNumber.append(temp)
        return arrNumber
    }
    
    // 6
    func reverse_arr( _ arr:[Int]) -> [Int] {
        return [arr[2],arr[1],arr[0]]
    }
    
    // 7
    func larg_num( _ arr:[Int]) -> [Int] {
        var arrNum = arr
        if arrNum.first! > arrNum.last! {
            arrNum[1] = arrNum.first!
            arrNum[2] = arrNum.first!
        } else {
            arrNum[0] = arrNum.last!
            arrNum[1] = arrNum.last!
        }
        return arrNum
    }
    
    // 8
    func sumOf_firstSecond( _ arr:[Int]) -> Int {
        let temp = arr.count
        if temp > 1 {
            return arr[0] + arr[1]
        } else {
            return arr[0]
        }
    }
    
    // 9
    func middle_element( _ arr1:[Int], arr2:[Int]) -> [Int] { // [1,2,3] [8,5,4]
        var arr: [Int] = []
        arr = [arr1[1],arr2[1]]
        return arr
    }
    
    // 10
    func first_last( _ arr:[Int]) -> [Int] { // [9,5,4]
        var arrNum: [Int] = []
        arrNum.append(arr[0])
        arrNum.append(arr.last!)
        return arrNum
    }
    
    // 11
    func check_num_is3or5( _ arr:[Int]) { // [3,8,5]
        //        for i in 0..<arr.count {
        //            if arr[i] == 3 || arr[i] == 5 {
        //                print("true")
        //            } else {
        //
        //            }
        //        }
        if arr.contains(3) || arr.contains(5) {
            print("true")
        }
    }
    
    // 12
    func check_num_is3not5( _ arr:[Int]) { // [3,8,5]
        if arr.contains(3) || arr.contains(5) {
            print("false")
        } else {
            print("true")
        }
    }
    
    //13
    func doubleArr( _ arr:[Int]) -> [Int] {
        var newArr: [Int] = [arr.last!]
        for _ in arr {
            newArr.insert(0, at: newArr.startIndex)
            newArr.insert(0, at: newArr.startIndex)
        }
        newArr.remove(at: 0)
        return newArr
    }
    
    // 14
    func check_twice( _ arr:[Int]) -> Bool {
        var count = 0
        for i in 0..<arr.count {
            if arr[i] == 3 || arr[i] == 5 {
                count = count + 1
            }
        }
        if count > 1 {
            return true
        }
        return false
    }
    
    // 15
    func check_position( _ arr1:[Int], arr2:[Int]) -> Bool {
        if arr1.first == 0 && arr2.first == 0 {
            return true
        }
        return false
    }
    
    // 16
    func sum_arr( _ arr1:[Int], arr2:[Int]) -> [Int] {
        if (arr1[0] + arr1[1]) >= (arr2[0] + arr2[1]) {
            return arr1
        } else  {
            return arr2
        }
    }
    
    // 18
    func containFour_arr( _ arr1:[Int], arr2:[Int]) -> [Int] {
        var new_arr: [Int] = []
        new_arr.append(contentsOf: arr1)
        new_arr.append(contentsOf: arr2)
        return new_arr
    }
    
    // 19
    func swap_num(_ arr:[Int]) -> [Int] {
        var arr1 = arr
        let first = arr1.removeFirst()
        let last = arr1.removeLast()
        arr1.insert(last, at: arr1.startIndex)
        arr1.append(first)
        return arr1
    }
    
    // 20
    func middle_array( _ arr:[Int]) -> [Int] {
        var newArr = arr
        
        if arr.count % 2 == 1 {
            let count = arr.count
            let second_value = count / 2
            let thidrd_value = second_value + 1
            let first_value = second_value - 1
            newArr = [arr[first_value],arr[second_value],arr[thidrd_value]]
        }
        return newArr
    }
    
    //21
    func find_largestNum( _ arr:[Int]) -> Int { // [5,3,6]
        let middle_value = arr.count / 2
        if arr.first! > arr.last! && arr.first! > arr[middle_value] {
            return arr.first!
        } else if arr.last! > arr.first! && arr.last! > arr[middle_value] {
            return arr.last!
        } else {
            return arr[middle_value]
        }
    }
    
    // 22
    func first_twoElement( _ arr:[Int]) -> [Int] {
        let arr1 = arr
        var first: [Int] = []
        first = [arr[0]]
        if arr1.count <= 2 {
            return first
        }
        let newArr = [arr1[0],arr1[1]]
        return newArr
    }
    
    // 23
    func first_element( _ arr1:[Int], arr2:[Int]) -> [Int] {
        if arr1.count == 0 {
            return [arr2[0]]
        }
        if arr2.count == 0 {
            return [arr1[0]]
        }
        let newArr = [arr1[0],arr2[0]]
        return newArr
    }
    
    // 24
    func even_number( _ arr:[Int]) -> Int {
        for i in 0..<arr.count {
            if arr[i] % 2 == 0 {
                return i
            }
        }
        return 0
    }
    
    // 25
    func largeNum( _ arr:[Int]) -> Int { // [2,4,5,8,2]
        var large = 0
        var small = 0
        for _ in 0..<arr.count {
            large = arr.max()!
            small = arr.min()!
        }
        return large - small
    }
    
    // 26
    func sumOf_number( _ arr:[Int]) -> Int {
        var sum = 0
        var ans = true
        for i in 0..<arr.count {
            if arr[i] != 11 && ans == true {
                sum = sum + arr[i]
                ans = true
            } else {
                ans = false
            }
        }
        return sum
    }
    
    // 27
    func check_3nextTo3( _ arr:[Int]) -> Bool {
        for i in 0..<arr.count-1 {
            if arr[i] == 3 && arr[i+1] == 3 {
                return true
            }
        }
        return false
    }
    
    //28
    func check1isGreter_3( _ arr:[Int]) -> Bool {
        var value_1 = 0
        var value_3 = 0
        for i in 0..<arr.count {
            if arr[i] == 1 {
                value_1 = value_1 + 1
            } else if arr[i] == 3 {
                value_3 = value_3 + 1
            }
        }
        return value_1 > value_3
    }
    
    // 29
    func everyElement_is2or5( _ arr:[Int]) -> Bool {
        for i in 0..<arr.count {
            if arr[i] != 2 && arr[i] != 5 {
                return false
            }
        }
        return true
    }
    
    // 30
    func notContains_2or5( _ arr:[Int]) -> Bool {
        if arr.contains(2) && arr.contains(5) {
            return false
        } else {
            return true
        }
    }
    
    // 31
    func check5is_nextTo5( _ arr:[Int]) -> Bool {
        for i in 0..<arr.count {
            if (arr[i] == 3 && arr[i+1] == 3) || (arr[i] == 5 && arr[i+1] == 5) {
                return true
            }
        }
        return false
    }
    
    // 32
    func two5nextTonext_saprated( _ arr:[Int]) -> Bool {
        for i in 0..<arr.count {
            if (arr[i] == 5 && arr[i+1] == 5) || (arr[i] == 5 && arr[i+2] == 5) {
                return true
            }
        }
        return false
    }
    
    // 33
    func check1iswith3( _ arr:[Int]) -> Bool {
        for i in 0..<arr.count {
            if arr[i] == 1 {
                for j in 0..<arr.count {
                    if arr[j] == 3 {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    // 34
    func checkOddEven_nextTonext( _ arr:[Int]) -> Bool{
        for i in 0..<arr.count-1 {
            if (arr[i] % 2 == 0 && arr[i+1] % 2 == 0) || (arr[i] % 2 == 1 && arr[i+1] % 2 == 1) {
                return true
            }
        }
        return false
    }
    
    // 35
    func check5is_TwoTime( _ arr:[Int]) -> Bool {
        var count = 0
        for i in 0..<arr.count {
            if arr[i] == 5 {
                count = count + 1
            }
        }
        for i in 0..<arr.count-1 {
            if arr[i] == 5 && arr[i+1] == 5 {
                return false
            } else {
                return true
            }
        }
        if count == 2 {
            return true
        } else {
            return false
        }
    }
    
    // 36
    func check3_isNextto3( _ arr:[Int]) -> Bool {
        for i in 0..<arr.count {
            if (arr[i] == 3) == (arr[i+1] == 3) {
                return true
            }
        }
        return false
    }
    
    // 37
    func checkAdajcent_number( _ arr:[Int]) -> Bool {
        for i in 0..<arr.count-2 {
            if arr[i] == arr[i+1] - 1  && arr[i+1] == arr[i+2] - 1 {
                return true
            }
        }
        return false
    }
    
    // 38
    func leftShifted( _ arr:[Int]) -> [Int] {
        var newArr = arr
        var finalArr = 0
        finalArr = newArr.removeFirst()
        newArr.append(finalArr)
        return newArr
    }
}
