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
            webSocket = try HTTPClient.webSocket(hostname: Constants.host,
                                                 port: Constants.port,
                path: "/connect/\(clientID)",
                on: MultiThreadedEventLoopGroup.init(numberOfThreads: 1)).wait()
            
            webSocket.onText { webSocket, text in
                print(text)
            }
            
            webSocket.onBinary { webSocket, data in
                print(data)
            }
            
//            try self.webSocket.onClose.wait()
            
            completion()
            
        } catch {
            print(error)
        }
    }
}
