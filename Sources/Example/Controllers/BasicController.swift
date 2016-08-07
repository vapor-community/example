import Vapor
import HTTP

public final class BasicController {
    let drop: Droplet
    public init(droplet: Droplet) {
        drop = droplet
    }

    /**
        This first route will return the welcome.html
        view to any request to the root directory of the website.

        Views referenced with `app.view` are by default assumed
        to live in <workDir>/Resources/Views/ 

        You can override the working directory by passing
        --workDir to the application upon execution.
    */
    public func welcome(_ request: Request) throws -> ResponseRepresentable {
        return try drop.view("welcome.html")
    }

    /**
        This simple plaintext response is useful
        when benchmarking Vapor.
    */
    public func plaintext(_ request: Request) throws -> ResponseRepresentable {
        return "Hello, world!"
    }
}
