import Foundation

struct LocalClient: Encodable {
    var hostName: String
    var userName: String
    var osType: String
    var osVersion: String
    var kernelType: String
    var kernelVersion: String
    var state: String
    
    static func fresh() -> LocalClient {
        
        let hostName = CLI.runCommand(args: "hostname").output.first!
        let userName = CLI.runCommand(args: "whoami").output.first!
        let kernelType = CLI.runCommand(args: "uname").output.first!
        let kernelVersion = CLI.runCommand(args: "uname", "-r").output.first!
        #if os(Linux)
        CLI.runCommand(args: "source", "/etc/os-release")
        let osType = CLI.runCommand(args: "bash", "Scripts/linuxOSType.bash").output.first!
        let osVersion = CLI.runCommand(args: "bash", "Scripts/linuxOSVersion.bash").output.first!
        #else
        let osType = CLI.runCommand(args: "sw_vers", "-productName").output.first!
        let osVersion = CLI.runCommand(args: "sw_vers", "-productVersion").output.first!
        #endif
            
        let state = ClientState.ready.rawValue
        
        let localClient = LocalClient(hostName: hostName,
                                  userName: userName,
                                  osType: osType,
                                  osVersion: osVersion,
                                  kernelType: kernelType,
                                  kernelVersion: kernelVersion,
                                  state: state)
        return localClient
    }
}
