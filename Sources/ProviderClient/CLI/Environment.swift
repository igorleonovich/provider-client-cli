import Foundation

struct Environment {
    
    private static let homePath = ProcessInfo.processInfo.environment["HOME"]
    private static let filePath = "\(homePath!)/.provider_client_id"
    
    static var clientID: String? {
        get {
            let providerClientID = CLI.runCommand(args: "cat", filePath).output.first!
            return providerClientID.isEmpty ? nil : providerClientID
        }
        set {
            if let newValue = newValue {
                do {
                    try newValue.write(toFile: filePath, atomically: true, encoding: .utf8)
                } catch {
                    print(error)
                }
            } else {
                CLI.runCommand(args: "rm", filePath)
            }
        }
    }
}
