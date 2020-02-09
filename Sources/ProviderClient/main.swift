import Foundation

let clientController = ClientController()

func connect() {
    
    if let clientID = Environment.clientID {
        let webSocketClient = WebSocketClient(clientID: clientID)
        webSocketClient.start() {
            clientController.getFullClientUpdateData() { fullClientUpdateData in
                webSocketClient.webSocket.send(fullClientUpdateData)
            }
        }
    } else {
        clientController.createClient()
    }
}

connect()

RunLoop.main.run()
