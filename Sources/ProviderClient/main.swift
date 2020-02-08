import Foundation
import Alamofire

let defaults = UserDefaults.standard
defaults.removeObject(forKey: "clientID")

func connect() {
    
    if let clientID = defaults.string(forKey: "clientID") {
        
        let webSocketClient = WebSocketClient(clientID: clientID)
        webSocketClient.start()
        
    } else {
        
        let hostName = Sysctl.hostName
        let userName = "whoami"
        let osType = Sysctl.osType
        let osRelease = Sysctl.osRelease
        let state = ClientState.ready.rawValue
        
        let newClient = NewClient(hostName: hostName,
                                  userName: userName,
                                  osType: osType,
                                  osRelease: osRelease,
                                  state: state)
        
        AF.request("http://localhost:8888/clients",
                   method: .post,
                   parameters: newClient,
                   encoder: JSONParameterEncoder.default).responseDecodable(of: Client.self) { response in
                    
            debugPrint(response)
                    
            if let createdClient = response.value {
                defaults.set(createdClient.id, forKey: "clientID")
                connect()
            }
        }
    }
}

connect()

RunLoop.main.run()
