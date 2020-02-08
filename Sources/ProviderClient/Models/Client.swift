import Foundation

struct NewClient: Encodable {
    var hostName: String
    var userName: String
    var osType: String
    var osRelease: String
    var state: String
}

struct Client: Decodable {
    var id: String
    var hostName: String
    var userName: String
    var osType: String
    var osRelease: String
    var state: String
}

enum ClientState: String {
    case unknown
    case ready
    case progress
    case running
}
