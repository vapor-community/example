import Vapor
import Mustache
import Fluent

public final class User: Model {
    public var id: Node?
    var name: String
    
    init(id: Node? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: Node Conversions
extension User {
    public convenience init(node: Node, in context: Vapor.Context) throws {
        self.init(
            id: try node.extract("id"),
            name: try node.extract("name")
        )
    }

    public func makeNode() throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
        ])
    }
}
