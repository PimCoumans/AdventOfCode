import Foundation
import Algorithms

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



extension Collection {
	func reduceFromFirstElement(_ reducer: (Element, Element) -> Element) -> Element {
		dropFirst().reduce(first!, reducer)
	}
	/// Get tuple of first two values, error when not available
	var firstTwoValues: (first: Element, second: Element) {
		precondition(count >= 2)
		return (self[startIndex], self[index(after: startIndex)])
	}
}

extension Collection where Element: BinaryInteger {
	func sum() -> Element {
		reduce(0, +)
	}
}

protocol Day {
	associatedtype Output1
	associatedtype Output2
	/// Supply your input string here, preferably in an extension at the bottom of the `Day#.swift` file
	static var input: String { get }
	
	/// Called automatically with  input string when using an empty initializer
	/// - Parameter input: Value of provided `static var input`
	init(input: String)
	
	/// Result of part two of this day‘s challenge
	func partOne() -> Output1
	/// Result of part two of this day‘s challenge
	func partTwo() -> Output2
}

extension Day {
	/// Initializes `Day` with its `input`
	init() {
		self.init(input: Self.input)
	}
}
