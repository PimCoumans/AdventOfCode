import Foundation

struct Day9: Day {

	let values: [[Int]]

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//-3 0 3 6 9 12 15
//1 3 6 10 15 21
//10 13 16 21 30 45
//"""
		self.values = self.input
			.linesByDroppingTrailingEmpty()
			.map { $0
				.components(separatedBy: .whitespaces)
				.compactMap(Int.init)
			}
	}

	func predictedValue(for history: [Int], debug: Bool = false) -> Int {
		var differences: [[Int]] = [history]
		while differences.last!.sum() != 0 {
			differences.append(
				Array(
					differences
						.last!
						.windows(ofCount: 2)
						.map(\.firstTwoValues)
						.map { $1 - $0 }
				)
			)
		}
		if debug {
			for row in differences {
				print(row)
			}
		}
		return differences
			.map { $0.last! }
			.sum()
	}

	func partOne() -> Int {return values.map {
			predictedValue(for: $0)
		}.sum()
	}

	func partTwo() -> Int {
		0
	}
}
