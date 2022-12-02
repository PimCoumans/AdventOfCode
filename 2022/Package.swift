// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "2022",
    products: [
		.executable(name: "2020", targets: ["2022"])
    ],
    dependencies: [
		
    ],
    targets: [
		.executableTarget(
			name: "2022",
			swiftSettings: [.unsafeFlags(["-O"])]
		)
    ]
)
