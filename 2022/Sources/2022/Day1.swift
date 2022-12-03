import Foundation

struct Day1: Day {
	
	struct Elf {
		let snacks: [Int]
		let totalCalories: Int
		
		init(snacksString: String) {
			snacks = snacksString
				.components(separatedBy: .newlines)
				.compactMap(Int.init(_:))
			totalCalories = snacks.reduce(0, +)
		}
	}
	
	/// List of elfs sorted by total snack calories, high to low
	let elfs: [Elf]
	
	init(input: String) {
		let input = Day1.input
		
		self.elfs = input
			.components(separatedBy: "\n\n")
			.map( Elf.init(snacksString:) )
			.sorted(by: { $0.totalCalories > $1.totalCalories })
	}
	
	func partOne() -> String {
		String(elfs.first!.totalCalories)
	}
	
	func partTwo() -> String {
		let count = 3
		let total = elfs[0..<count].map(\.totalCalories).reduce(0, +)
		return String(total)
	}
}
