import Foundation

func connect() {
    
    if let clientID = Environment.clientID {
        
        let webSocketClient = WebSocketClient(clientID: clientID)
        webSocketClient.start()
        
        // let localClient = LocalClient.fresh()
        // send updated client via ws
        // ws.send("running")
        
    } else {
        
        let localClient = LocalClient.fresh()
        ClientController.create(with: localClient) { createdClient, error in
            if let createdClient = createdClient {
                Environment.clientID = createdClient.id
                connect()
            }
        }
    }
}

connect()

RunLoop.main.run()
