import Vapor
import HTTP
import Routing

extension Application {
	public func routes(_ drop: Droplet) {
		// MARK: Basic
        let basic = BasicController(droplet: drop)
        drop.get(handler: basic.welcome)
        drop.get("plaintext", handler: basic.plaintext)


        // MARK: JSON
        let json = JSONController()
        drop.get("math", Int.self, handler: json.math)
        drop.get("user", User.self, handler: json.user)
        drop.get("json", handler: json.json)

        // MARK: Board
        let board = BoardController(droplet: drop)
        drop.resource("board", board)


        //MARK: Magic
        /**
            Vapor allows your program to group requests together
            for easily adding common prefixes, middleware, or host
            multiple routes.
        */
        drop.group("magic") { magic in
            magic.get(handler: json.magic)
            magic.get("encore", handler: json.encore)
        }

        /**
            This will set up the appropriate GET, PUT, and POST
            routes for basic CRUD operations. Check out the
            UserController in App/Controllers to see more.

            Resources are also type-safe, with their types being
            defined by which StringInitializable class they choose
            to receive as parameters to their functions.
        */
        let users = UserController(droplet: drop)
        drop.resource("users", users)


        /**
			Route collections help break routing up into different
			files. This route collection takes a controller.
        */
        let misc = MiscController(droplet: drop)
        let miscCollection = MiscCollection(misc)
        drop.collection(miscCollection)

        // MARK: Databse
        /**
            Here is an example of a route without a controller.

            This provides an endpoint to check that your datbase
            is working and what version it's running.
        */
        drop.get("db-version") { request in
            guard let database = drop.database else {
                return "Your database is not set up. Please see the README.md."
            }
            
            guard let version = try database.driver.raw("SELECT @@version AS version")[0].object?["version"].string else {
                return try JSON(["error": "Could not get database version."])
            }
            
            return try JSON([
                "version": version
            ])
        }
	}
}
