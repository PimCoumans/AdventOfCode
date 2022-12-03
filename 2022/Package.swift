// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "2022",
    products: [
		.executable(name: "2022", targets: ["2022"])
    ],
    dependencies: [
		.package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0")
    ],
    targets: [
		.executableTarget(
			name: "2022",
			dependencies: [
				.product(name: "Algorithms", package: "swift-algorithms")
			],
			swiftSettings: [/*.unsafeFlags(["-O"])*/]
		),
		.testTarget(name: "2022Tests", dependencies: ["2022"])
    ]
)
