import Foundation
import UIKit

extension URL {
    func isURLAvailable() -> Bool {
        let filePath = self.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            return true
        }
        else {
            return false
        }
    }
}
