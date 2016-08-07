import Vapor
import VaporMySQL
import VaporMustache

extension Application {
	public var providers: [Vapor.Provider.Type] {
		return [
			VaporMySQL.Provider.self,
			VaporMustache.Provider.self
		]
	}
}
