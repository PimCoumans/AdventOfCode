import Foundation

extension StringProtocol {
	var isNotEmpty: Bool { !isEmpty }
}

extension StringProtocol {

	func lineBlocks() -> [[String]] where Self == String {
		blocks().map { $0.lines() }
	}

	func lineBlocksByDroppingTrailingEmpty() -> [[String]] where Self == String {
		blocks().map { $0.linesByDroppingTrailingEmpty() }
	}

	func blocks() -> [String] {
		components(separatedBy: "\n\n")
	}

	func lines() -> [String] {
		components(separatedBy: .newlines)
	}

	func linesByDroppingTrailingEmpty() -> [String] {
		lines().prefix(while: \.isNotEmpty)
	}

	func trimmedLines() -> [String] {
		components(separatedBy: .newlines)
			.map { $0.trimmingCharacters(in: .whitespaces) }
	}

	func elements() -> [String] {
		components(separatedBy: .whitespaces)
	}
}
