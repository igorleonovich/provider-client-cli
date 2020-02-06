import Foundation
import Starscream

class WSClient: WebSocketDelegate {
    
    var socket: WebSocket!
    var isConnected = false
    
    init() {
        socket = WebSocket(url: URL(string: "ws://localhost:8888/echo")!)
        socket.delegate = self
        socket.connect()
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
        socket.write(string: "⛳️")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("received: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}

let wsc = WSClient()
print("...")
RunLoop.main.run()
