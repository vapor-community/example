import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .Package(url: "https://github.com/tannernelson/vapor.git", majorVersion: 1),
		//.Package(url: "../vapor", majorVersion: 1),
    ]
)
