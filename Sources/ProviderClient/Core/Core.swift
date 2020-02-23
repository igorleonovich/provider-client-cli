import Foundation

class Core {
    
    var clientController: ClientController!
    var statsController: StatsController!
    var webSocketController: WebSocketController?
    
    func setup() {
        clientController = ClientController(core: self)
        statsController = StatsController(core: self)
    }
    
    func connect(_ completion: @escaping () -> Void) {
        if let clientID = Environment.clientID {
            webSocketController = WebSocketController(core: self, clientID: clientID)
            webSocketController!.start {
                completion()
            }
        } else {
            createClient {
               self.connect(completion)
            }
        }
    }
    
    func createClient(_ completion: @escaping () -> Void) {
        core.clientController.createClient {
            completion()
        }
    }
    
    func fullClientUpdate(_ completion: @escaping () -> Void) {
        core.clientController.getFullClientUpdateData() { fullClientUpdateData in
            core.webSocketController?.webSocket.send(fullClientUpdateData)
            completion()
        }
    }
}
