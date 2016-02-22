import Vapor

class SampleMiddleware: Middleware {

	func handle(handler: Request -> Response) -> (Request -> Response) {
		return { request in
			// You can manipulate the request before calling the handler
			// and abort early if necessary, a good injection point for
			// handling auth.

			// return Response(status: .Forbidden, text: "Permission denied")

			let response = handler(request)

			// You can also manipulate the response to add headers
			// cookies, etc.

			return response
		}
	}

}
