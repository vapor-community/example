import PackageDescription

let package = Package(
    name: "VaporExample",
    dependencies: [
        .Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 0, minor: 12),
		.Package(url: "https://github.com/qutheory/vapor-mustache.git", majorVersion: 0, minor: 8)
    ],
    exclude: [
	    "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
		"Tests",
    ]
)
