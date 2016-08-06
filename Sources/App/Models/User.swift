import Vapor
import Mustache
import Fluent

public final class User: Model {
    public var id: Node?
    var name: String // The username belonging to this user
    
    init(name: String) {
        self.name = name // TODO: Validator
    }

    public init(node: Node, in context: Vapor.Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }

    public func makeNode() throws -> Node {
        return try Node(node: [
			"id": id,
            "name": name
        ])
    }

    public static func prepare(_ database: Database) throws {
		try database.create(entity) { users in
			users.id()
			users.string("name")
		}
    }

    public static func revert(_ database: Database) throws {
        try database.delete(entity)
    }
	
	func posts() -> Children<Post> {
		return children(Post.self)
	}
	
	func postCount() throws -> Int {
		return try children(Post.self).all().count // TODO: Make more efficient? Raw query?
	}
}
