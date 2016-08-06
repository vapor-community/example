import Vapor
import VaporMySQL
import VaporMustache
import HTTP


/**
    Droplets are service containers that make accessing
    all of Vapor's features easy. Just call
    `drop.serve()` to serve your application
    or `drop.client()` to create a client for
    request data from other servers.
*/
let drop = Droplet(providers: [VaporMustache.Provider.self])

/**
    Vapor configuration files are located
    in the root directory of the project
    under `/Config`.

    `.json` files in subfolders of Config
    override other JSON files based on the
    current server environment.

    Read the docs to learn more
*/
let _ = drop.config["app", "key"].string ?? ""

/**
    This first route will return the welcome.html
    view to any request to the root directory of the website.

    Views referenced with `app.view` are by default assumed
    to live in <workDir>/Resources/Views/ 

    You can override the working directory by passing
    --workDir to the application upon execution.
*/
drop.get("/") { request in
    return try drop.view("welcome.html")
}

/**
    Return JSON requests easy by wrapping
    any JSON data type (String, Int, Dict, etc)
    in JSON() and returning it.

    Types can be made convertible to JSON by 
    conforming to JsonRepresentable. The User
    model included in this example demonstrates this.

    By conforming to JsonRepresentable, you can pass
    the data structure into any JSON data as if it
    were a native JSON data type.
*/
drop.get("json") { request in
    return try JSON([
        "number": 123,
        "string": "test",
        "array": try JSON([
            0, 1, 2, 3
        ]),
        "dict": try JSON([
            "name": "Vapor",
            "lang": "Swift"
        ])
    ])
}

/**
    This route shows how to access request
    data. POST to this route with either JSON
    or Form URL-Encoded data with a structure
    like:

    {
        "users" [
            {
                "name": "Test"
            }
        ]
    }

    You can also access different types of
    request.data manually:

    - Query: request.data.query
    - JSON: request.data.json
    - Form URL-Encoded: request.data.formEncoded
    - MultiPart: request.data.multipart
*/
drop.get("data", Int.self) { request, int in
    return try JSON([
        "int": int,
        "name": request.data["name"].string ?? "no name"
    ])
}

/**
	Here's an example of using type-safe routing to ensure
	only requests to "math/<some-float>" will be handled.

	String is the most general and will match any request
	to "route/<some-string>".

	Vapor currently limits you to three path components.
	When you need more than three path components,
	consider using a group.
*/
drop.get("math", Int.self) { request, number in
	return try JSON([
		"number":      number,
		"number * 2":  number * 2,
		"number / 2":  number / 2,
		"number << 2": number << 2
	])
}

/**
	Any type that conforms to `StringInitializable` can be used
	as a type-safe routing parameter. The `User` model included
	in this example is `StringInitializable`, so it can be
	used as a parameter.
*/
drop.get("user", User.self) { request, user in
	return try JSON([
		"success": true,
		"user": user
	])
}

/**
	Vapor allows your program to group requests together
	for easily adding common prefixes, middleware, or host
	multiple routes.
*/
drop.group("magic") { magic in
	magic.get("/") { request in
		return try JSON([
			"abracadabra": "✨ 🎩🐰 ✨"
		])
	}
	
	magic.get("encore") { request in
		return try JSON([
			"tada": "✨ 👱🔪⚰👣 ✨"
		])
	}
}

/**
    This will set up the appropriate GET, PUT, and POST
    routes for basic CRUD operations. Check out the
    UserController in App/Controllers to see more.

    Controllers are also type-safe, with their types being
    defined by which StringInitializable class they choose
    to receive as parameters to their functions.
*/

let users = UserController(droplet: drop)
drop.resource("users", users)

/**
    VaporMustache hooks into Vapor's view class to
    allow rendering of Mustache templates. You can
    even reference included files setup through the provider.
*/
drop.get("mustache") { request in // TODO: Giving a server error `Server error: dispatch(HTTP.ParserError.streamEmpty)`
    return try drop.view("template.mustache", context: [
        "greeting": "Hello, world!"
    ])
}

/**
    A custom validator definining what
    constitutes a valid name. Here it is 
    defined as an alphanumeric string that
    is between 5 and 20 characters.
*/
class Name: ValidationSuite {
    static func validate(input value: String) throws {
        let evaluation = OnlyAlphanumeric.self
            && Count.min(5)
            && Count.max(20)

        try evaluation.validate(input: value)
    }
}

/**
    By using `Valid<>` properties, the
    employee class ensures only valid
    data will be stored.
*/
class Employee {
    var email: Valid<Email>
    var name: Valid<Name>

    init(request: Request) throws {
        email = try request.data["email"].validated()
        name = try request.data["name"].validated()
    }
}

/**
    Allows any instance of employee
    to be returned as Json
*/
extension Employee: JSONRepresentable {
    func makeJSON() throws -> JSON {
        return try JSON([
            "email": email.value,
            "name": name.value
        ])
    }
}

// TODO: Temporarily unavailable
//drop.any("validation") { request in
//    return try Employee(request: request)
//}

/**
    This simple plaintext response is useful
    when benchmarking Vapor.
*/
drop.get("plaintext") { request in
    return "Hello, World!"
}

/**
    Vapor automatically handles setting
    and retreiving sessions. Simply add data to
    the session variable and–if the user has cookies
    enabled–the data will persist with each request.
*/
drop.get("session") { request in
    let json = try JSON([
        "session.data": "\(request.session)",
        "request.cookies": "\(request.cookies)",
        "instructions": "Refresh to see cookie and session get set."
    ])
    var response = try Response(status: .ok, json: json)

    request.session?["name"] = "Vapor"
    response.cookies["test"] = "123"

    return response
}

/**
    Add Localization to your app by creating
    a `Localization` folder in the root of your
    project.

    /Localization
       |- en.json
       |- es.json
       |_ default.json

    The first parameter to `app.localization` is
    the language code.
*/
drop.get("localization", String.self) { request, lang in
    return try JSON([
        "title": drop.localization[lang, "welcome", "title"],
        "body": drop.localization[lang, "welcome", "body"]
    ])
}

/**
	Vapor makes hashing strings easy. This is great
	for things like securely storing passwords.

	You can also change the default hasher like:

	let sha512 = SHA2Hasher(variant: .sha512)
	let drop = Droplet(hash: sha512)

	Additionally, you can create your own hasher
	simply by conforming to the `Hash` protocol.
*/
drop.get("hash", String.self) { request, hashValue in
	return try JSON([
		"hashed": drop.hash.make(hashValue)
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

let port = drop.config["app", "port"].int ?? 80

// Print what link to visit for default port
drop.serve()
