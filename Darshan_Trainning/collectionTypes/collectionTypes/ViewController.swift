import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Collection type
        
        // Array
        var shoppingList: [String] = ["Eggs", "Milk"]
        shoppingList.append("Flour")
        shoppingList += ["Baking Powder"]
        shoppingList.insert("Syrup", at: 0)
        shoppingList.remove(at: 0)
        shoppingList.removeLast()
        print(shoppingList)
        
        // Set
        let letters = Set<Character>()
        var generes: Set = ["a","b","d","e"]
        generes.remove("a")
        generes.insert("c")
        print("letters is of type Set<Character> with \(letters.count) items.")
        print(generes)
        
        // Dictionary
        let a = ["abc":"ABC",
                 "qwe":"QWE"]
        print("\(a.count)")
        for i in a.keys{
            print(i)
        }
    }
}
