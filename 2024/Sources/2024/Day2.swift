import Foundation

struct Day2: Day {
	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//7 6 4 2 1
//1 2 7 8 9
//9 7 6 2 1
//1 3 2 4 5
//8 6 4 4 1
//1 3 6 7 9
//"""
		reports = self.input
			.linesByDroppingTrailingEmpty()
			.map { $0
				.components(separatedBy: .whitespaces)
				.map { Int($0)! }
			}
	}

	let reports: [[Int]]

	func isSafeReport(_ report: [Int]) -> Bool {
		let startDirection = (report[0] - report[1]).signum()
		return report
			.windows(ofCount: 2)
			.map(\.firstTwoValues)
			.map { $0 - $1 }
			.allSatisfy {
				$0.signum() == startDirection && (1...3).contains(abs($0))
			}
	}

	func partOne() -> Int {
		reports.count(where: isSafeReport(_:))
	}

	func partTwo() -> Int {
		0
	}
}
