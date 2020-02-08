import Foundation

struct Environment {
    
    private static let clientIDKey = "PROVIDER_CLIENT_ID"
    
    static func getClientID() -> String? {
        getVariable(name: clientIDKey)
    }
    
    static func setClientID(_ newValue: String) {
        setVariable(name: clientIDKey, value: newValue, overwrite: true)
    }
  
    private static func setVariable(name: String, value: String, overwrite: Bool) {
        setenv(name, value, overwrite ? 1 : 0)
    }
    
    private static func getVariable(name: String) -> String? {
        let processInfo = ProcessInfo.processInfo
        guard let value = processInfo.environment[name] else {
            return nil
        }
        return value
    }
}
