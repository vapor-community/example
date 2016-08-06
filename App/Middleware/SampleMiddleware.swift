import Vapor
import HTTP

class SampleMiddleware: Middleware {

	func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        /**
			You can manipulate the request before calling the handler
			and abort early if necessary, a good injection point for
			handling auth. For instance:
		
			return Response(status: .Forbidden, text: "Permission denied")
		
			You can also manipulate the response to add headers
			cookies, etc.
		
			However, for this example, we simply pass it on to the
			other middleware and do nothing with it.
		*/
		
        let response = try chain.respond(to: request)
		
        return response

		/**
			Vapor Middleware is based on S4 Middleware.
			This means you can share it with any other project
			that uses S4 Middleware.
		*/
	}

}
