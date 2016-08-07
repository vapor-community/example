import Vapor
import VaporMustache

extension Application {
    public var providers: [Vapor.Provider.Type] {
        return [
            VaporMustache.Provider.self
        ]
    }
}
