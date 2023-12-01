import Foundation
import Algorithms

protocol Day {
	associatedtype Output1
	associatedtype Output2

	/// Supply your input string here, preferably in an separate file
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
