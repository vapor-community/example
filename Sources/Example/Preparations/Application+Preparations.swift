import Fluent

extension Application {
	public var preparations: [Preparation.Type] {
		return [
			Post.self, 
			User.self
		]
	}
}
