import Foundation
import WebSocket

class WebSocketClient {
    
    var webSocket: WebSocket!
    var clientID: String
    
    init(clientID: String) {
        self.clientID = clientID
    }
    
    func start(_ completion: @escaping () -> Void) {
        
        do {
            webSocket = try HTTPClient.webSocket(hostname: "localhost",
                port: 8888,
                path: "/connect/\(clientID)",
                on: MultiThreadedEventLoopGroup.init(numberOfThreads: 1)).wait()
            
            self.webSocket.onText { webSocket, text in
                // process server messages (config deployment)
            }
            
//            try self.webSocket.onClose.wait()
            
            completion()
            
        } catch {
            print(error)
        }
    }
}
