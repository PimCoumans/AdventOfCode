import Foundation

struct Day1: Day {
	let input: String
	init(input: String) {
		self.input = input
	}

	func partOne() -> Int {
		let numbers = input
			.lines()
			.map {
				String($0.first(where: { $0.isNumber })!) +
				String($0.last(where: { $0.isNumber })!)
			}
			.map { Int($0)! }
		return numbers.sum()
	}

	func partTwo() -> Int {
		0
	}
}
