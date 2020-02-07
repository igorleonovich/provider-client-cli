import Foundation

struct NewClient: Encodable {
    var hostname: String
    var state: String
}

struct Client: Decodable {
    var id: String
    var hostname: String
    var state: String
}
