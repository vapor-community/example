import Vapor
import Fluent

final class Post: Model {
	var id: Node?
	var text: String
	var userId: Node? // TODO: Describe one many relationship
	
	init(text: String, userId: Node) {
		self.text = text
		self.userId = userId
	}
	
	init(node: Node, in context: Context) throws {
		id = try node.extract("id")
		text = try node.extract("text")
		userId = try node.extract("user_id")
	}
	
	func makeNode() throws -> Node {
		return try Node(node: [
			"id": id,
			"text": text,
			"user": try user().get()
		])
	}
	
	static func prepare(_ database: Database) throws {
		// TODO: Describe
		try database.create(entity) { users in
			users.id()
			users.string("username")
			users.int("user_id")
		}
		
	}
	
	static func revert(_ database: Database) throws {
		// TODO: Describe
		try database.delete(entity)
	}
	
	func user() throws -> Parent<User> {
		// TODO: Describe
		return try parent(userId)
	}
}

