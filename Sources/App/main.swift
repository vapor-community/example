import Vapor
import HTTP

/**
    Droplets are service containers that make accessing
    all of Vapor's features easy. Just call
    `drop.serve()` to serve your application
    or `drop.client()` to create a client for
    request data from other servers.
*/
let drop = Droplet()

/**
    Vapor configuration files are located
    in the root directory of the project
    under `/Config`.

    `.json` files in subfolders of Config
    override other JSON files based on the
    current server environment.

    Read the docs to learn more
*/
let _ = drop.config["app", "key"]?.string ?? ""

/**
    This first route will return the welcome.html
    view to any request to the root directory of the website.

    Views referenced with `app.view` are by default assumed
    to live in <workDir>/Resources/Views/

    You can override the working directory by passing
    --workDir to the application upon execution.
*/
drop.get("/") { request in
    // Get the next meetup from the meetup.com API
    let meetupResponse = try drop.client.get("https://api.meetup.com/mi-swift/events?photo-host=public&page=1&sig_id=92233812")
    if let response = try JSON(bytes: meetupResponse.body.bytes!)[0] {
        // If we have data from the API, pass it to the template
        return try drop.view.make("home", Node(node: response))
    } else {
        return try drop.view.make("home")
    }
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

let port = drop.config["app", "port"]?.int ?? 80

// Print what link to visit for default port
drop.run()
