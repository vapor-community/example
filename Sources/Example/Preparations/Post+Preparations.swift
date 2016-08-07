import Fluent

extension Post {
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
}
