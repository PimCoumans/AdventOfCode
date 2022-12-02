import Foundation

protocol Day {
	/// Supply your input string here, preferably in an extension at the bottom of the `Day#.swift` file
	static var input: String { get }
	
	/// Called automatically with  input string when using an empty initializer
	/// - Parameter input: Value of provided `static var input`
	init(input: String)
	
	/// Result of part two of this day‘s challenge
	func partOne() -> String
	/// Result of part two of this day‘s challenge
	func partTwo() -> String
}

extension Day {
	/// Initializes `Day` with its `input`
	init() {
		self.init(input: Self.input)
	}
}
