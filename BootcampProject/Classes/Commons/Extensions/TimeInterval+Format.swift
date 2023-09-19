import Foundation

extension TimeInterval {
    
    var movieFormat: String {
        let totalSeconds = Int(self / 1000)
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds % 3600) / 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
    }
    
    var musicFormat: String {
        let totalSeconds = Int(self / 1000)
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds % 3600) / 60
        return String(format: "%02d:%02d", arguments: [minutes, seconds])
    }
}
