import Vapor

class HeartbeatController: ResourceController, DefaultInitializable {
    required init() { }

	/// List all resources
	func index(request: Request) throws -> ResponseRepresentable {
		return Json(["lub": "dub"])
	}

     /// Delete an instance.
    func destroy(request: Request, item: String) throws -> ResponseRepresentable {
        throw Abort.NotFound
    }
}
