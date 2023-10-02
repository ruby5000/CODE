import Foundation

struct CommonFunction {
    static let shared = CommonFunction()
    
    func getPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
