import Foundation

struct Day1: Day {
	
	/// List of total calories per elf, sorted from low to high
	let sortedTotalCalories: [Int]
	
	init(input: String) {
		let input = Day1.input
		
		self.sortedTotalCalories = input
			.components(separatedBy: "\n\n")
			.map { $0
				.components(separatedBy: .newlines)
				.compactMap(Int.init(_:))
				.reduce(0, +)
			}
			.sorted()
	}
	
	func partOne() -> String {
		String(sortedTotalCalories.last!)
	}
	
	func partTwo() -> String {
		let count = 3
		let total = sortedTotalCalories.suffix(3)
			.reduce(0, +)
		return String(total)
	}
}
