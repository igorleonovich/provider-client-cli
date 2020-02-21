import Foundation
import SPMUtility

public final class CLITool {
    
    func run() {
        let parser = ArgumentParser(commandName: "pc", usage: "pc -h hostname -p port", overview: "Provider Client")
        let hostArgument = parser.add(option: "--host", shortName: "-h", kind: String.self, usage: "Use custom host name")
        let portArgument = parser.add(option: "--port", shortName: "-p", kind: Int.self, usage: "Use custom port")
        let versionOption = parser.add(option: "--version", kind: Bool.self)
        let verboseOption = parser.add(option: "--verbose", kind: Bool.self, usage: "Show more debugging information")
        
        do {
            let result = try parser.parse(Array(CommandLine.arguments.dropFirst()))
            if let version = result.get(versionOption) {
                print("ProviderClient 0.1.0")
                return
            }
            
            if let host = result.get(hostArgument) {
                Constants.host = host
            }
            
            if let port = result.get(portArgument) {
                Constants.port = port
            }
        } catch {
            print(error)
        }
    }
}
