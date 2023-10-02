import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txt_value: UITextField!
    @IBOutlet weak var txt_value2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btn_submit(_ sender: UIButton) {
        
        //        for i in 1...10 {
        //            print(i, terminator: " ")
        //        }
        
        //        var sum = 0
        //        for i in 1...10 {
        //            sum = sum + i
        //        }
        //        print(sum)
        
        //        var sum = 0
        //        var input: Int? = Int(self.txt_value.text!)
        //        for i in 1...input! {
        //            sum = sum + i
        //        }
        //        print(sum)
        
        //         var avg = 0
        //         var sum = 0
        //         var input: Int? = Int(self.txt_value.text!)
        //                for i in 1...input! {
        //                    sum = sum + i
        //                }
        //                avg = sum / input!
        //                print(avg)
        
        //        var cube = 0
        //        var input: Int? = Int(self.txt_value.text!)
        //        for i in 1...input! {
        //            cube = i*i*i
        //            print("Number is : \(i) and cube of the \(i) is \(cube)")
        //        }
        
        //        var table = 0
        //        var input: Int? = Int(self.txt_value.text!)
        //        for i in 1...10 {
        //            table = input! * i
        //            print("\(input!) x \(i) = \(table)")
        //        }
        
        //        var table = 0
        //        let input: Int? = Int(self.txt_value.text!)
        //        let input2: Int? = Int(self.txt_value2.text!)
        //        for j in input!...input2! {
        //            for i in 1...10 {
        //                table = j * i
        //                print("\(j)x\(i) = \(table),",terminator: " ")
        //            }
        //        }
        
        //        var sum = 0
        //        let input: Int? = Int(self.txt_value.text!)
        //        for i in 0...input!+input! {
        //            if i % 2 != 0 {
        //                sum = sum + i
        //                print(i,terminator: " ")
        //            }
        //        }
        //        print("\n")
        //        print(sum,terminator: " ")
        
//        var arrNum = [0]
//        let input: Int? = Int(self.txt_value.text!)
//        for i in 1...input! {
//            if i % 2 != 0 {
//                arrNum.append(i)
//                print(arrNum)
//            }
//        }
        
        
        
        //        for i in 0...3 {
        //            for j in 0...i {
        //                print("*", terminator: " ")
        //            }
        //            print("\n")
        //        }
        
        //        for i in 1...4 {
        //            for j in 1...i {
        //                print(j, terminator: " ")
        //            }
        //            print("\n")
        //        }
        
                var value = 0
                for i in 1...4 {
                    for j in 1...i {
                        value = i
                        print(value,terminator: " ")
                    }
                    print("\n")
                }
        
        
//                var value = 0
//                for i in 1...4 {
//                    for j in 1...i {
//                        value = value + 1
//                        print(value, terminator: " ")
//                    }
//                    print("\n")
//                }
    }
}
