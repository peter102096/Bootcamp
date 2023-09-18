import Foundation

class Global: NSObject {
    static let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    static var isDarkMode = false
}
