import Foundation

class Core {
    
    var clientController: ClientController!
    var stateController: StateController!
    var webSocketController: WebSocketController?
    
    func setup() {
        clientController = ClientController(core: self)
        stateController = StateController(core: self)
    }
    
    func connect(_ completion: (() -> Void)?) {
        
        if let clientID = Environment.clientID {
            webSocketController = WebSocketController(core: self, clientID: clientID)
            webSocketController!.start() {
                completion?()
            }
        } else {
            createClient {
               self.connect(nil)
            }
        }
    }
    
    func createClient(_ completion: @escaping () -> Void) {
        core.clientController.createClient {
            completion()
        }
    }
    
    func updateClient(_ completion: @escaping () -> Void) {
        core.clientController.getFullClientUpdateData() { fullClientUpdateData in
            core.webSocketController?.webSocket.send(fullClientUpdateData)
            completion()
        }
    }
}
