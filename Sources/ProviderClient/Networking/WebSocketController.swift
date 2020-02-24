import Foundation
import WebSocket

class WebSocketController {
    
    weak var core: Core?
    var clientID: String
    var webSocket: WebSocket!
    
    init(core: Core, clientID: String) {
        self.core = core
        self.clientID = clientID
    }
    
    func start(_ completion: @escaping (Error?) -> Void) {
        
        do {
            print("\(Date()) [ws] connecting")
            webSocket = try HTTPClient.webSocket(hostname: Constants.host,
                                                 port: Constants.wsPort,
                path: "/connect/\(clientID)",
                on: MultiThreadedEventLoopGroup.init(numberOfThreads: 1)).do { webSocket in
                    print("\(Date()) [ws] connected")
            }.catch { error in
                print(error)
            }.wait()
            
            webSocket.onText { webSocket, text in
//                print("\(Date()) [ws] [text from server] \(text)")
                if text == "clientID OK" {
                print("\(Date()) [ws] [clientID OK]")
                    completion(nil)
                } else if text == "clientID FAIL" {
                    print("\(Date()) [ws] [clientID FAIL]")
                    completion(Error.clientIDNotFoundOnServer)
                }
            }
            
            webSocket.onBinary { webSocket, data in
                print("\(Date()) [ws] [data from server] \(data)")
            }
            
            _ = self.webSocket.onClose.map {
               print("\(Date()) [ws] [closed]")
            }
            
        } catch {
            print(error)
        }
    }
}

extension WebSocketController {
    enum Error: Swift.Error {
        case clientIDNotFoundOnServer
    }
}
