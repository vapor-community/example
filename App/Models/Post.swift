import Vapor
import Mustache
import Fluent

final class Post: Model { // TODO: Add date posted
	var id: Node?
	var text: String
	var userId: Node? // TODO: Describe one many relationship
	
	init(text: String, user: User?) {
		self.text = text // TODO: Validator
		self.userId = user?.id
	}
	
	init(node: Node, in context: Vapor.Context) throws {
		id = try node.extract("id")
		text = try node.extract("text")
		userId = try node.extract("user_id")
	}
	
	func makeNode() throws -> Node {
		return try Node(node: [
			"id": id,
			"text": text,
//			"user": try user().get() // TODO: Why is this not working?
			"user_id": userId
		])
	}
	
	static func prepare(_ database: Database) throws {
		// TODO: Describe
		try database.create(entity) { users in
			users.id()
			users.string("text")
			users.int("user_id")
		}
		
	}
	
	static func revert(_ database: Database) throws {
		// TODO: Describe
		try database.delete(entity)
	}
	
	func user() throws -> Parent<User> {
		// TODO: Describe
		return try parent(userId, User.self)
	}
}

extension Post: MustacheBoxable {
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
		case "text":
			return text.mustacheBox
		case "user":
			return try! user().get()!.mustacheBox
		default:
			return Box()
		}
	}
}

