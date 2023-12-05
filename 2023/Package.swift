// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "2023",
    products: [
		.executable(name: "2023", targets: ["2023"])
    ],
    dependencies: [
		.package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0")
    ],
    targets: [
		.executableTarget(
			name: "2023",
			dependencies: [
				.product(name: "Algorithms", package: "swift-algorithms")
			],
			resources: [
				.process("Resources/Inputs")
			],
			swiftSettings: [.unsafeFlags(["-O"])]
		),
		.testTarget(name: "2023Tests", dependencies: ["2023"])
    ]
)
