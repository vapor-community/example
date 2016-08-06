import Vapor
import VaporMySQL
import VaporMustache
import Fluent
import HTTP
import App

/**
    Droplets are service containers that make accessing
    all of Vapor's features easy. Just call
    `drop.serve()` to serve your application
    or `drop.client()` to create a client for
    request data from other servers.

    As you can see, the droplet is given two providers. A
    provider gives a way for adding functionality from
    third party packages to Vapor. Here, we set up
    VaporMustache for rendering views and VaporMySQL
    for our database.
*/
let drop = Droplet(
    preparations: [Post.self, User.self],
    providers: [VaporMustache.Provider.self, VaporMySQL.Provider.self]
)

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


//M MARK: Magic
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



// MARK: Misc
let misc = MiscController(droplet: drop)
drop.get("data", Int.self, handler: misc.data)
drop.get("mustache", handler: misc.mustache)
drop.get("localization", String.self, handler: misc.localization)
drop.get("hash", String.self, handler: misc.hash) 
drop.get("config", handler: misc.config)

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

/**
    Middleware is a great place to filter 
    and modifying incoming requests and outgoing responses. 

    Check out the middleware in App/Middleware.

    You can also add middleware to a single route by
    calling the routes inside of `app.middleware(MiddlewareType) { 
        app.get() { ... }
    }`
*/
drop.middleware.append(SampleMiddleware())


// MARK: Serve

drop.serve()
