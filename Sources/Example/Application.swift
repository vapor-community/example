import Vapor
import HTTP

/**
    This Application class is optional in Vapor,
    but is being used to structure this large Example.
*/
public final class Application {
    public var drop: Droplet?

    public init(testing: Bool = false) {
        var args = Process.arguments
        if testing {
            // simulate passing `--env=testing` from the 
            // command line if testing is true.
            args.append("--env=testing")
        }

        /**
            Droplets are service containers that make accessing
            all of Vapor's features easy. Just call
            `drop.serve()` to serve your application
            or `drop.client()` to create a client for
            request data from other servers.
        */
        let drop = Droplet(
            arguments: args,
            providers: providers
        )

        /**
            Passes the Droplet to have routes added from the routes folder.
        */
        routes(drop)

        /**
            Middleware is a great place to filter 
            and modifying incoming requests and outgoing responses.
        */
        drop.middleware += middleware

        self.drop = drop
    }

    /**
        Starts the application by serving the Droplet.
    */
    public func start() {
        drop?.serve()
    }
}
