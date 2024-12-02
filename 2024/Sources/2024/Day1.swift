import Foundation

struct Day1: Day {
	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//3   4
//4   3
//2   5
//1   3
//3   9
//3   3
//"""
	}

	func partOne() -> Int {
		var lists: [[Int]] = [[], []]
		for line in input.linesByDroppingTrailingEmpty() {
			let parts = line
				.components(separatedBy: .whitespaces)
				.filter(\.isNotEmpty)
				.firstTwoValues
			lists[0].append(Int(parts.first)!)
			lists[1].append(Int(parts.second)!)
		}
		lists = lists.map { $0.sorted() }
		let distance = zip(lists[0], lists[1]).reduce(0) { partialResult, values in
			partialResult + abs(values.0 - values.1)
		}
		return distance
	}

	func partTwo() -> Int {
		0
	}
}
