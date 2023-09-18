import Foundation

extension Int {
    var musicFormat: String {
        let totalSeconds = self / 1000
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds % 3600) / 60
        return String(format: "%02d:%02d", arguments: [minutes, seconds])
    }
    var movieFormat: String {
        let totalSeconds = self / 1000
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds % 3600) / 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
    }
    
}
