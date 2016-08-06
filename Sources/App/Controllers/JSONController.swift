import Vapor
import HTTP

public final class JSONController {
    public init() { }

    /**
        Here's an example of using type-safe routing to ensure
        only requests to "math/<some-float>" will be handled.

        String is the most general and will match any request
        to "route/<some-string>".

        Vapor currently limits you to three path components.
        When you need more than three path components,
        consider using a group.
    */
    public func math(_ request: Request, number: Int) throws -> ResponseRepresentable {
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
    public func user(_ request: Request, user: User) throws -> ResponseRepresentable {
        return try JSON([
            "success": true,
            "user": user
        ])
    }

    public func magic(_ request: Request) throws -> ResponseRepresentable {
        return try JSON([
            "abracadabra": "✨ 🎩🐰 ✨"
        ])
    }

    public func encore(_ request: Request) throws -> ResponseRepresentable {
        return try JSON([
            "tada": "✨ 👱🔪⚰👣 ✨"
        ])
    }

    /**
        As you may have already noticed, you can
        make JSON responses easily by wrapping
        any JSON data type (String, Int, Dict, etc)
        in `JSON()` and returning it.

        Types can be made convertible to JSON by 
        conforming to `JsonRepresentable`. The User
        model included in this example demonstrates this.

        By conforming to `JsonRepresentable`, you can pass
        the data structure into any JSON data as if it
        were a native JSON data type.
    */
    public func json(_ request: Request) throws -> ResponseRepresentable {
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
}
