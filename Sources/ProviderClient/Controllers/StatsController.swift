import Foundation
import ProviderSDK

class StatsController {
    
    weak var core: Core?
    
    init(core: Core) {
        self.core = core
    }
    
    func startStatsUpdating() {
        
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                
                guard let `self` = self, let core = self.core else { return }
                
                core.clientController.currentLocalClient?.cpuUsage = ClientInfo.cpuUsage
                core.clientController.currentLocalClient?.freeRAM = ClientInfo.freeRAM
                
                guard let currentLocalClient = core.clientController.currentLocalClient else { return }
                
                // Check updates
                
                var newLocalClient = LocalClient()
                var shouldUpdate = false
                
                if currentLocalClient.state != core.clientController.previousLocalClient!.state {
                    newLocalClient.state = currentLocalClient.state
                    shouldUpdate = true
                }
                if currentLocalClient.cpuUsage != core.clientController.previousLocalClient!.cpuUsage {
                    newLocalClient.cpuUsage = currentLocalClient.cpuUsage
                    shouldUpdate = true
                }
                if currentLocalClient.freeRAM != core.clientController.previousLocalClient!.freeRAM {
                    newLocalClient.freeRAM = currentLocalClient.freeRAM
                    shouldUpdate = true
                }
                
                core.clientController.previousLocalClient = core.clientController.currentLocalClient
                
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
