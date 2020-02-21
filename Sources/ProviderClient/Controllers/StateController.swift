import Foundation
import ProviderSDK

class StateController {
    
    weak var core: Core?
    
    init(core: Core) {
        self.core = core
    }
    
    func startStateUpdating() {
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            
            guard let `self` = self, let core = self.core else { return }
            
            
            // Vary state
            var newState = ClientState.ready
            let randomNumber = Int.random(in: 1...3)
            switch randomNumber {
            case 1:
                newState = ClientState.ready
            case 2:
                newState = ClientState.progress
            case 3:
                newState = ClientState.running
            default:
                newState = ClientState.unknown
            }
            
            if let currentLocalClient = core.clientController.currentLocalClient {
                var newLocalClient = currentLocalClient
                newLocalClient.state = newState.rawValue
                core.clientController.currentLocalClient = newLocalClient
            }
            
            // Check updates
            
            if let previousLocalClient = core.clientController.previousLocalClient,
                let currentLocalClient = core.clientController.currentLocalClient {
                
                if currentLocalClient.state != previousLocalClient.state {
                    
                    // Send updated object
                    do {
                        let updatedClient = LocalClient(state: currentLocalClient.state!)
                        let updatedClientData = try JSONEncoder().encode(updatedClient)
                        let clientToServerAction = ClientToServerAction(type: ClientToServerActionType.partialClientUpdate.rawValue, data: updatedClientData)
                        let clientToServerActionData = try JSONEncoder().encode(clientToServerAction)
                        core.webSocketController?.webSocket.send(clientToServerActionData)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
