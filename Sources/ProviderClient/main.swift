import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let defaults = UserDefaults.standard
defaults.removeObject(forKey: "clientID")

func connect() {
    
    if let clientID = defaults.string(forKey: "clientID") {
        
        let webSocketClient = WebSocketClient(clientID: clientID)
        webSocketClient.start()
        
    } else {
        
        let hostName = "whoami"
        let userName = "whoami"
        let osType = "whoami"
        let osRelease = "whoami"
        let state = ClientState.ready.rawValue
        
        let newClient = NewClient(hostName: hostName,
                                  userName: userName,
                                  osType: osType,
                                  osRelease: osRelease,
                                  state: state)
        
        if let url = URL(string: "http://localhost:8888/clients") {
            do {
                let data = try JSONEncoder().encode(newClient)
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
                            let createdClient = try JSONDecoder().decode(Client.self, from: data)
                            defaults.set(createdClient.id, forKey: "clientID")
                            connect()
                        } catch {
                            print(error)
                        }
                    }
                }
                task.resume()
            } catch {
                print(error)
            }
        }
    }
}

connect()

RunLoop.main.run()
