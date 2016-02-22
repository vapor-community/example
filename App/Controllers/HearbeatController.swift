import Vapor

class HeartbeatController: Controller {

	override func index(request: Request) -> ResponseConvertible {
		return ["lub": "dub"]
	}

}
