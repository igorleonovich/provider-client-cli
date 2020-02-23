import Foundation

struct ProviderClient: Decodable {
    var id: String
    var hostName: String?
    var userName: String?
    var osType: String?
    var osVersion: String?
    var kernelType: String?
    var kernelVersion: String?
    var state: String?
}
