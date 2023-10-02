import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK: - Public
// declarations are accessible from everywhere
class PublicClass {
    public var valueA: Int = 10
    public var valueB: Int = 10
    public func addtion() {
        print(valueA+valueB)
    }
}

// MARK: - Private
// declarations are accessible only within the defined class or struct
class PrivateClass {
    private var valueA: Int = 10
    private var valueB: Int = 10
    private func addtion() {
        print(valueA+valueB)
    }
}

// MARK: - File Private
// declarations are accessible only within the current swift file
class FilePrivateClass {
    fileprivate var valueA: Int = 100
    fileprivate var valueB: Int = 10
    fileprivate func addtion() {
        print(valueA+valueB)
    }
}

// MARK: - Internal
// declarations are accessible only within the defined module (default)
class InternalClass {
    internal var valueA: Int = 10
    internal var valueB: Int = 10
    internal func addtion() {
        print(valueA+valueB)
    }
}


// MARK: - Advance Oprator

// Bitwise AND Operator
// a & b
// The bitwise AND operator returns 1 if and only if both the operands are 1. Otherwise, it returns 0.


// Bitwise OR Operator
// a | b
// The bitwise OR | operator returns 1 if at least one of the operands is 1. Otherwise, it returns 0.


// Bitwise XOR Operator
// a ^ b
// The bitwise XOR ^ operator returns 1 if and only if one of the operands is 1. However, if both the operands are 0, or if both are 1, then the result is 0.


// Bitwise NOT Operator
// a ~ b
// The bitwise NOT ~ operator inverts the bit( 0 becomes 1, 1 becomes 0).


// Left Shift Operator
// a << b
// The left shift operator shifts all bits towards the left by a specified number of bits. It is denoted by <<.


// Right Shift Operator
// a >> b
// The right shift operator shifts all bits towards the right by a certain number of specified bits. It is denoted by >>.
