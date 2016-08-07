import Vapor
import HTTP
import Routing

class MiscCollection: RouteCollection {
	let misc: MiscController
	init(_ controller: MiscController) {
		misc = controller
	}

    typealias Wrapped = HTTP.Responder
    func build<B: RouteBuilder where B.Value == Wrapped>(_ builder: B) {
        // MARK: Misc
        builder.get("data", Int.self, handler: misc.data)
        builder.get("mustache", handler: misc.mustache)
        builder.get("localization", String.self, handler: misc.localization)
        builder.get("hash", String.self, handler: misc.hash)
        builder.get("config", handler: misc.config)
    }
}
