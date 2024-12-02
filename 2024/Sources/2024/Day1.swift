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
		var leftList: [Int] = []
		var rightList: [Int] = []
		for line in input.linesByDroppingTrailingEmpty() {
			let parts = line
				.components(separatedBy: .whitespaces)
				.filter(\.isNotEmpty)
				.firstTwoValues
			leftList.append(Int(parts.first)!)
			rightList.append(Int(parts.second)!)
		}
		self.leftList = leftList.sorted()
		self.rightList = rightList.sorted()
	}

	let leftList: [Int]
	let rightList: [Int]

	func partOne() -> Int {
		zip(leftList, rightList).reduce(0) { distance, values in
			distance + abs(values.0 - values.1)
		}
	}

	func partTwo() -> Int {
		leftList.reduce(0) { score, value in
			score + value * rightList.count(where: { $0 == value })
		}
	}
}
