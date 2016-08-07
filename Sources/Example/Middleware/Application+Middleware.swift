import Vapor

extension Application {
	public var middleware: [Middleware] {
		return [
			SampleMiddleware()
		]
	}
}
