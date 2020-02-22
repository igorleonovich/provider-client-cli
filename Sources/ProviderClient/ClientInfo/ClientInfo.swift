import Foundation

struct ClientInfo {
    
    static var osType: String {
        #if os(Linux)
        return "linux"
        #else
        return "macos"
        #endif
    }
    
    static var cpuUsage: Double? {
        if let cpuUsageString = CLI.runCommand(args: "bash", "Scripts/\(osType)CPUUsage.bash").output.first,
            let cpuUsage = Double(cpuUsageString) {
            return cpuUsage
        }
        return nil
    }
    
    static var freeRAM: Int? {
        if let freeRAMString = CLI.runCommand(args: "bash", "Scripts/\(osType)FreeRAM.bash").output.first,
            let freeRAM = Int(freeRAMString) {
            return freeRAM
        }
        return nil
    }
}
