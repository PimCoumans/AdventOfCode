import Foundation

struct Day1: Day {
	
	/// List of total calories per elf, sorted from low to high
	let sortedTotalCalories: [Int]
	
	init(input: String) {
		self.sortedTotalCalories = input
			.components(separatedBy: "\n\n")
			.map { snacksString in
				snacksString
					.components(separatedBy: .newlines)
					.compactMap(Int.init(_:))
					.reduce(0, +)
			}
			.sorted()
	}
	
	func partOne() -> Int {
		sortedTotalCalories.last!
	}
	
	func partTwo() -> Int {
		sortedTotalCalories
			.suffix(3)
			.reduce(0, +)
	}
}
