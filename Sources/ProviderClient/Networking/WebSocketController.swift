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
    
    func start(_ completion: @escaping () -> Void) {
        
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
                print("\(Date()) [ws] [text from server] \(text)")
            }
            
            webSocket.onBinary { webSocket, data in
                print("\(Date()) [ws] [data from server] \(data)")
            }
            
            _ = self.webSocket.onClose.map {
               print("\(Date()) [ws] [closed]")
            }
            
            completion()
            
        } catch {
            print(error)
        }
    }
}
