import Vapor
//import VaporZewoMustache

let app = Application()

/**
	This first route will return the welcome.html
	view to any request to the root directory of the website.

	Views referenced with `app.view` are by default assumed
	to live in <workDir>/Resources/Views/ 

	You can override the working directory by passing
	--workDir to the application upon execution.
*/
app.get("/") { request in
	return try app.view("welcome.html")
}

/**
	Return JSON requests easy by wrapping
	any JSON data type (String, Int, Dict, etc)
	in Json() and returning it.

	Types can be made convertible to Json by 
	conforming to JsonRepresentable. The User
	model included in this example demonstrates this.

	By conforming to JsonRepresentable, you can pass
	the data structure into any JSON data as if it
	were a native JSON data type.
*/
app.get("json") { request in
    return Json([
        "string": "test"
    ])
	/*return Json([
		"number": 123,
		"string": "test",
		"array": [
			0, 1, 2, 3
		],
		"dict": [
			"name": "Vapor",
			"lang": "Swift"
		]
	])*/
}

/**
	This route shows the various ways to access 
	request data with a manual (not type safe) route.

	Visit "data/<some-string>" to view the output.
*/
app.any(path: "data/:id") { request in
	return Json([
		"request.path": request.uri.path ?? "",
		"request.data": "\(request.data)",
		"request.parameters": "\(request.parameters)",
	])
}

/**
	Here's an example of using type-safe routing to ensure 
	only requests to "posts/<some-integer>" will be handled.

	String is the most general and will match any request
	to "posts/<some-string>". To make your data structure
	work with type-safe routing, make it StringInitializable.

	The User model included in this example is StringInitializable.
*/
app.get("posts", Int.self) { request, postId in 
	return "Requesting post with ID \(postId)"
}

/**
	This will set up the appropriate GET, PUT, and POST
	routes for basic CRUD operations. Check out the
	UserController in App/Controllers to see more.

	Controllers are also type-safe, with their types being
	defined by which StringInitializable class they choose
	to receive as parameters to their functions.
*/
app.resource("users", controller: UserController.self)

/**
	VaporZewoMustache hooks into Vapor's view class to
	allow rendering of Mustache templates. You can 
	even reference included files setup through the provider.
*/
app.get("mustache") { request in
	return try app.view("template.mustache", context: [
		"greeting": "Hello, world!"
	])
}

/**
	This simple plaintext response is useful
	when benchmarking Vapor.
*/
app.get("plaintext") { request in
	return "Hello, World!"
}

/**
	Vapor automatically handles setting
	and retreiving sessions. Simply add data to
	the session variable and–if the user has cookies
	enabled–the data will persist with each request.
*/
app.get("session") { request in
	let json = Json([
		"session.data": "\(request.session)",
		"request.cookies": "\(request.cookies)",
		"instructions": "Refresh to see cookie and session get set."
	])
	var response = Response(status: .ok, json: json)

	request.session?["name"] = "Vapor"
	response.cookies["test"] = "123"

	return response
}

/* VaporZewoMustache awaiting upgrade.
/**
	Appending a provider allows it to boot
	and initialize itself as a dependency.
*/
app.providers.append(VaporZewoMustache.Provider(withIncludes: [
    "header": "Includes/header.mustache"
]))
*/

/**
	Middleware is a great place to filter 
	and modifying incoming requests and outgoing responses. 

	Check out the middleware in App/Middelware.

	You can also add middleware to a single route by
	calling the routes inside of `app.middleware(MiddelwareType) { 
		app.get() { ... }
	}`
*/
app.middleware.append(SampleMiddleware())

// Print what link to visit for default port
print("Visit http://localhost:8080")
app.start(port: 8080)
