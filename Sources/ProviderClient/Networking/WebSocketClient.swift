import Foundation
import WebSocket

class WebSocketClient {
    
    var webSocket: WebSocket!
    var clientID: String
    
    init(clientID: String) {
        self.clientID = clientID
    }
    
    func start() {
        
        do {
            let ws = try HTTPClient.webSocket(hostname: "localhost",
                port: 8888,
                path: "/connect/\(clientID)",
                on: MultiThreadedEventLoopGroup.init(numberOfThreads: 1))
                .wait()

            ws.onText { ws, text in
                // process server messages (config deployment)
            }
            
            try ws.onClose.wait()
            
        } catch {
            print(error)
        }
    }
}
