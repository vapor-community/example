import HTTP
import URI
import Transport
import Example

enum HTTPTestError: Error {
    case invalidBodyType
    case noDroplet
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

extension Application: Responder {
    public func respond(to request: Request) throws -> Response {
        guard let drop = self.drop else {
            throw HTTPTestError.noDroplet
        }

        return try drop.respond(to: request)
    }
}
