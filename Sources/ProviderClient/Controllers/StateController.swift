import Foundation
import ProviderSDK

class StateController {
    
    weak var core: Core?
    
    init(core: Core) {
        self.core = core
    }
    
    func startStateUpdating() {
        
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                
                guard let `self` = self, let core = self.core,
                    let currentLocalClient = core.clientController.currentLocalClient else { return }
                
                if core.clientController.previousLocalClient == nil {
                    core.clientController.previousLocalClient = currentLocalClient
                }
                
                guard let previousLocalClient = core.clientController.previousLocalClient else { return }
                
                core.clientController.currentLocalClient?.cpuUsage = ClientInfo.cpuUsage
                core.clientController.currentLocalClient?.freeRAM = ClientInfo.freeRAM
                
                // Check updates
                
                var newLocalClient = LocalClient()
                var shouldUpdate = false
                
                if currentLocalClient.state != previousLocalClient.state {
                    newLocalClient.state = currentLocalClient.state
                    shouldUpdate = true
                }
                if currentLocalClient.cpuUsage != previousLocalClient.cpuUsage {
                    newLocalClient.cpuUsage = currentLocalClient.cpuUsage
                    shouldUpdate = true
                }
                if currentLocalClient.freeRAM != previousLocalClient.freeRAM {
                    newLocalClient.freeRAM = currentLocalClient.freeRAM
                    shouldUpdate = true
                }
                
                // Send updated object
                
                if shouldUpdate {
                    do {
                        let updatedClientData = try JSONEncoder().encode(newLocalClient)
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
