import Vapor
import Mustache
import Fluent

final class Post: Model { // TODO: Add date posted
	var id: Node?
	var text: String // The text inside of teh post
	var userId: Node? // A post is a child of a User, so we need to keep track of the owner
	
	init(text: String, user: User?) {
		/**
			
		*/
		self.text = text // TODO: Validator
		self.userId = user?.id
	}
	
	init(node: Node, in context: Vapor.Context) throws {
		/**
			
		*/
		id = try node.extract("id")
		text = try node.extract("text")
		userId = try node.extract("user_id")
	}
	
	func makeNode() throws -> Node {
		/**
			
		*/
		return try Node(node: [
			"id": id,
			"text": text,
//			"user": try user().get() // TODO: Shouldn't this work?
			"user_id": userId
		])
	}
	
	static func prepare(_ database: Database) throws {
		/**
		
		*/
		try database.create(entity) { users in
			users.id()
			users.string("text")
			users.int("user_id")
		}
		
	}
	
	static func revert(_ database: Database) throws {
		/**
		
		*/
		try database.delete(entity)
	}
	
	func user() throws -> Parent<User> {
		/**
			
		*/
		return try parent(userId, User.self)
	}
}

/**
	Here, we must make the Post object
	usable from the Mustache documents,
	so we have to tell Mustache how this
	data behaves.
*/
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

