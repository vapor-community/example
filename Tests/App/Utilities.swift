import HTTP
import URI
import Transport

enum HTTPTestError: Error {
    case invalidBodyType
}

extension Request {
    convenience init(host: String = "test.host", method: Method = .get, path: String = "/") {
        let uri = URI(host: "", path: path)
        self.init(method: .get, uri: uri)
    }
}

extension ResponseRepresentable {
    func bodyString() throws -> String {
        switch try makeResponse().body {
        case .data(let data):
            return data.string
        default:
            throw HTTPTestError.invalidBodyType
        }
    }
}
