
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For-loop
        let a = ["qwe","asd","zxc"]
        for i in a {
            print(i)
        }
        
        // Nested-loop
        for i in 0...5 {
            for j in stride(from: 1, through: i, by: 1) {
                print(j, terminator: "")
            }
            print("\n")
        }
        
        // while loop
        let q = 10
        let w = 5
        while (q < w) {
        }
        
        // repeat while
        repeat {
        } while (q < w)
        
        // Switch
        let wq = "ewq"
        switch wq {
        case "ewq":
            print("ewq")
        case "iop":
            print("iop")
        default: break
        }
        
        // Control transfer statement
        // continue
        let puzzleInput = "great minds think alike"
        var puzzleOutput = ""
        let charactersToRemove: [Character] = ["a","e","i","o","u"]
        for character in puzzleInput {
            if charactersToRemove.contains(character) {
                continue
                //print(puzzleInput)
            }
            puzzleOutput.append(character)
        }
        print(puzzleOutput)
        
        // fallthrough
        let wtq = "ewq"
        switch wtq {
        case "ewq":
            print("ewq")
            fallthrough
        case "iop":
            print("iop")
        default: break
        }
    }
}
