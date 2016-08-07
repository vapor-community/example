import Fluent

extension User {
	public static func prepare(_ database: Database) throws {
		try database.create(entity) { users in
			users.id()
			users.string("name")
		}
    }

    public static func revert(_ database: Database) throws {
        try database.delete(entity)
    }
}
