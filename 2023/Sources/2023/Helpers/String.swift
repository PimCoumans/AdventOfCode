import Foundation

extension StringProtocol {

	func lineBlocks() -> [[String]] where Self == String {
		blocks().map { $0.lines() }
	}

	func blocks() -> [String] {
		components(separatedBy: "\n\n")
	}

	func lines() -> [String] {
		components(separatedBy: .newlines)
	}

	func trimmedLines() -> [String] {
		components(separatedBy: .newlines)
			.map { $0.trimmingCharacters(in: .whitespaces) }
	}

	func elements() -> [String] {
		components(separatedBy: .whitespaces)
	}
}
