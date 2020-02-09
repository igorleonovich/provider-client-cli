import Foundation

enum ClientToServerActionType: String {
    case fullClientUpdate
    case stateUpdate
}

struct ClientToServerAction: Encodable {
    var type: String
    var data: Data
}

//struct ServerToClientAction {
//    var type: ServerToClientActionType
//}
//
//enum ServerToClientActionType {
//    case deployConfig
//    case stopConfig
//    case startConfig
//    case restartConfig
//    case terminateConfig // or removeConfig
//}
