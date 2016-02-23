import Vapor

class HeartbeatController: Controller {

	override func index(request: Request) throws -> ResponseConvertible {
		return ["lub": "dub"]
	}

}
