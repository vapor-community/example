import Vapor
import Mustache
import Fluent

final class User: Model {
    var id: Node?
    var name: String // The username belonging to this user
    
    init(name: String) {
		/**
			
		*/
        self.name = name // TODO: Validator
    }

    init(node: Node, in context: Vapor.Context) throws {
		/**
			
		*/
        id = try node.extract("id")
        name = try node.extract("name")
    }

    func makeNode() throws -> Node {
		/**
			
		*//
        return try Node(node: [
			"id": id,
            "name": name
        ])
    }

    static func prepare(_ database: Database) throws {
		/**
		
		*/
		try database.create(entity) { users in
			users.id()
			users.string("name")
		}
    }

    static func revert(_ database: Database) throws {
		/**
			
		*/
        try database.delete(entity)
    }
	
	func posts() -> Children<Post> {
		/**
			
		*/
		return children(Post.self)
	}
	
	func postCount() throws -> Int {
		/**
			
		*/
		return try children(Post.self).all().count // TODO: Make more efficient? Raw query?
	}
}

/**
Here, we must make the Post object
usable from the Mustache documents,
so we have to tell Mustache how this
data behaves.
*/
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
