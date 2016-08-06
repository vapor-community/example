import Vapor
import Mustache
import Fluent

final class User: Model {
    var id: Node?
    var name: String
    
    init(name: String) {
		// TODO: Describe
        self.name = name // TODO: Validator
    }

    init(node: Node, in context: Vapor.Context) throws {
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

extension User: MustacheBoxable {
	var mustacheBox: MustacheBox {
		return MustacheBox(
			value: self,
			boolValue: nil,
			keyedSubscript: keyedSubscriptFunction,
			filter: nil,
			render: nil,
			willRender: nil,
			didRender: nil
		)
	}
	
	func keyedSubscriptFunction(key: String) -> MustacheBox {
		switch key {
		case "id":
			return (id?.int?.mustacheBox)!
		case "name":
			return name.mustacheBox
		case "post-count":
			return try! postCount().mustacheBox
		default:
			return Box()
		}
	}
}
