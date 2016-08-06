import Vapor
import Mustache
import Fluent

public final class Post: Model { // TODO: Add date posted
	public var id: Node?
	var text: String // The text inside of the post
	var userId: Node? // A post is a child of a User, so we need to keep track of the owner
	
	init(text: String, user: User?) {
		self.text = text // TODO: Validator
		self.userId = user?.id
	}
	
	public init(node: Node, in context: Vapor.Context) throws {
		id = try node.extract("id")
		text = try node.extract("text")
		userId = try node.extract("user_id")
	}
	
	public func makeNode() throws -> Node {
		return try Node(node: [
			"id": id,
			"text": text,
			"user": try user().get(),
			"user_id": userId
		])
	}
	
	public static func prepare(_ database: Database) throws {
		try database.create(entity) { users in
			users.id()
			users.string("text")
			users.int("user_id")
		}
		
	}
	
	public static func revert(_ database: Database) throws {
		try database.delete(entity)
	}
	
	func user() throws -> Parent<User> {
		return try parent(userId, User.self)
	}
}

