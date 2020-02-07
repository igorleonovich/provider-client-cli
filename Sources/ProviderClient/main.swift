import Foundation
import Alamofire

let defaults = UserDefaults.standard
defaults.removeObject(forKey: "clientID")

func connect() {
    if let clientID = defaults.string(forKey: "clientID") {
        let wsc = WSClient(clientID: clientID)
        wsc.socket.connect()
    } else {
        let newClient = NewClient(hostname: "test-host", state: "unknown")
        AF.request("http://localhost:8888/clients", method: .post, parameters: newClient, encoder: JSONParameterEncoder.default).responseDecodable(of: Client.self) { response in
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
