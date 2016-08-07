import Vapor
import HTTP

/**
    By using `Valid<>` properties, the
    employee class ensures only valid
    data will be stored.
*/
class Employee {
    var email: Valid<Email>
    var name: Valid<Name>

    init(request: Request) throws {
        email = try request.data["email"].validated()
        name = try request.data["name"].validated()
    }
}

/**
    Allows any instance of employee
    to be returned as JSON
*/
extension Employee: JSONRepresentable {
    func makeJSON() throws -> JSON {
        return try JSON([
            "email": email.value,
            "name": name.value
        ])
    }
}
