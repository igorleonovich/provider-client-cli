import Foundation
import Starscream

class WSClient: WebSocketDelegate {
    
    var socket: WebSocket!
    var isConnected = false
    var clientID: String
    
    init(clientID: String) {
        self.clientID = clientID
        socket = WebSocket(url: URL(string: "ws://localhost:8888/connect/\(clientID)")!)
        socket.delegate = self
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
        isConnected = true
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
        isConnected = false
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("received: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}
