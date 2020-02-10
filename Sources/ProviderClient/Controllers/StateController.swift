import Foundation
import ProviderSDK

class StateController {
    
    weak var core: Core?
    
    init(core: Core) {
        self.core = core
    }
    
    func startStateBroadcasting() {
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            
            guard let `self` = self, let core = self.core else { return }
            
            let randomNumber = Int.random(in: 1...3)
            switch randomNumber {
            case 1:
                core.clientController.state = .ready
            case 2:
                core.clientController.state = .progress
            case 3:
                core.clientController.state = .running
            default:
                core.clientController.state = .unknown
            }
            
            if let stateData = core.clientController.state.rawValue.data(using: .utf8) {
                let clientToServerAction = ClientToServerAction(type: ClientToServerActionType.stateUpdate.rawValue, data: stateData)
                do {
                    let clientToServerActionData = try JSONEncoder().encode(clientToServerAction)
                    core.webSocketController?.webSocket.send(clientToServerActionData)
                } catch {
                    print(error)
                }
            }
        }
    }
}
