import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class ClientController {
    
    static func create(with localClient: LocalClient, completion: @escaping (Client?, Error?) -> Void) {
        if let url = URL(string: "http://localhost:8888/clients") {
            do {
                let data = try JSONEncoder().encode(localClient)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")

                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print(error)
                    } else if let data = data {
                        do {
                            let createdClient = try JSONDecoder().decode(Client.self, from: data)
                            completion(createdClient, nil)
                        } catch {
                            completion(nil, error)
                        }
                    }
                }
                task.resume()
            } catch {
                print(error)
            }
        }
    }

}
