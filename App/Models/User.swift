import Vapor
import Fluent

final class User: Model {
    var id: Node?
    var name: String
    
    init(name: String) {
		// TODO: Describe
        self.name = name
    }

    init(node: Node, in context: Context) throws {
		// TODO: Describe
        id = try node.extract("id")
        name = try node.extract("name")
    }

    func makeNode() throws -> Node {
		// TODO: Describe
        return try Node(node: [
			"id": id,
            "name": name
        ])
    }
	
	func makeJSON() -> JSON {
		// TODO: Note converting and overriding for clients
		return try! JSON([
			"id": try! JSON(node: id),
			"name": name,
			"post-count": try! postCount()
		])
	}

    static func prepare(_ database: Database) throws {
		// TODO: Describe (entity is table name from reflection)
		try database.create(entity) { users in
			users.id()
			users.string("name")
		}
    }

    static func revert(_ database: Database) throws {
		// TODO: Describe
        try database.delete(entity)
    }
	
	func posts() -> Children<Post> {
		// TODO: Describe, maybe don't need Post.self, but makes clear
		return children(Post.self)
	}
	
	func postCount() throws -> Int {
		return try children(Post.self).all().count // TODO: Make more efficient?
	}
}
