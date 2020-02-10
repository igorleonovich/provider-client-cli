import Foundation

class Core {
    
    let clientController = ClientController()
    var webSocketClient: WebSocketClient?
    
    func connect() {
        
        if let clientID = Environment.clientID {
            webSocketClient = WebSocketClient(clientID: clientID)
            webSocketClient?.start() { [weak self] in
                self?.clientController.getFullClientUpdateData() { fullClientUpdateData in
                    self?.webSocketClient?.webSocket.send(fullClientUpdateData)
                    self?.startStateBroadcasting()
                }
            }
        } else {
            core.clientController.createClient()
        }
    }
    
    func startStateBroadcasting() {
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            let randomNumber = Int.random(in: 1...3)
//
//
//            switch randomNumber {
//            case 1:
//                self.clientController.state = .ready
//            case 2:
//                self.clientController.state = .progress
//            case 3:
//                self.clientController.state = .running
//            default:
//                self.clientController.state = .unknown
//            }
            
            if let stateData = self.clientController.state.rawValue.data(using: .utf8) {
                let clientToServerAction = ClientToServerAction(type: ClientToServerActionType.stateUpdate.rawValue, data: stateData)
                do {
                    let clientToServerActionData = try JSONEncoder().encode(clientToServerAction)
                    self.webSocketClient?.webSocket.send(clientToServerActionData)
                } catch {
                    print(error)
                }
            }
        }
    }
}
