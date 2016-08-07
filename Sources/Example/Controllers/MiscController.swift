import Vapor
import HTTP

public final class MiscController {
    let drop: Droplet

    public init(droplet: Droplet) {
        drop = droplet
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
    public func data(_ request: Request, int: Int) throws -> ResponseRepresentable {
        return try JSON([
            "int": int,
            "name": request.data["name"].string ?? "no name"
        ])
    }

    // MARK: Views
    /**
        VaporMustache hooks into Vapor's view class to
        allow rendering of Mustache templates. You can
        even reference included files setup through the provider.
    */
    public func mustache(_ request: Request) throws -> ResponseRepresentable {
        return try drop.view("template.mustache", context: [
            "greeting": "Hello, world!"
        ])
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
    public func localization(_ request: Request, lang: String) throws -> ResponseRepresentable {
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
    public func hash(_ request: Request, string: String) throws -> ResponseRepresentable {
        return try JSON([
            "hashed": drop.hash.make(string)
        ])
    }

    /**
        Vapor configuration files are located
        in the root directory of the project
        under `/Config`.

        `.json` files in subfolders of Config
        override other JSON files based on the
        current server environment.

        Read the docs to learn more
    */
    public func config(_ request: Request) throws -> ResponseRepresentable {
        return drop.config["app", "key"].string ?? ""
    }
}
