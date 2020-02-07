import Foundation

struct NewClient: Encodable {
    var hostname: String
}

struct Client: Decodable {
    var id: String
    var hostname: String
}
