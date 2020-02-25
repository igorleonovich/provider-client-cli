import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import ProviderSDK

final class ClientController {
    
    weak var core: Core?
    
    var previousLocalClient: ProviderLocalClient?
    var currentLocalClient: ProviderLocalClient? {
        didSet {
            if previousLocalClient == nil {
                previousLocalClient = currentLocalClient
            }
        }
    }
    
    init(core: Core) {
        self.core = core
    }
    
    func createClient(_ completion: @escaping (Error?) -> Void) {
        print("\(Date()) [setup] obtaining new client")
        let localClient = getFullFreshClient()
        print("\(Date()) [setup] sending new client to server")
        create(with: localClient) { createdClient, error in
            if let createdClient = createdClient {
                Environment.clientID = createdClient.id
                completion(nil)
                print("\(Date()) [setup] new client created")
            } else {
                completion(error)
            }
        }
    }
    
    func create(with localClient: ProviderLocalClient, completion: @escaping (ProviderClient?, Error?) -> Void) {
        if let url = URL(string: "\(Constants.baseURL)/clients") {
            do {
                let data = try JSONEncoder().encode(localClient)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")

                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print(error)
                    } else if let data = data {
                        do {
                            let createdClient = try JSONDecoder().decode(ProviderClient.self, from: data)
                            completion(createdClient, nil)
                        } catch {
                            completion(nil, error)
                        }
                    }
                }
                task.resume()
            } catch {
                print(error)
            }
        }
    }
    
    func getFullClientUpdateData(_ completion: @escaping (Data) -> Void) {
        
        do {
            let localClient = getFullFreshClient()
            let localClientData = try JSONEncoder().encode(localClient)
            let clientToServerAction = ClientToServerAction(type: ClientToServerActionType.fullClientUpdate.rawValue,
                                                          data: localClientData)
            let clientToServerActionData = try JSONEncoder().encode(clientToServerAction)
            print("\(Date()) [fullClientUpdate] \(localClient)")
            completion(clientToServerActionData)
        } catch {
            print(error)
        }
    }
    
    func getFullFreshClient() -> ProviderLocalClient {
        
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
        
        let cpuUsage = ClientInfo.cpuUsage
        let freeRAM = ClientInfo.freeRAM
        let state = ProviderClientState.unknown.rawValue
        
        let localClient = ProviderLocalClient(hostName: hostName,
                                  userName: userName,
                                  osType: osType,
                                  osVersion: osVersion,
                                  kernelType: kernelType,
                                  kernelVersion: kernelVersion,
                                  state: state,
                                  cpuUsage: cpuUsage,
                                  freeRAM: freeRAM)
        self.currentLocalClient = localClient
        
        return localClient
    }
}
