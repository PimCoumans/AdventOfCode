import Foundation

struct Day6: Day {

	let timeString: String
	let scoreString: String

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//Time:      7  15   30
//Distance:  9  40  200
//"""
		let (times, distances) = self.input
			.linesByDroppingTrailingEmpty()
			.map {
				$0
					.components(separatedBy: ":")
					.last!
			}
			.firstTwoValues

		self.timeString = times
		self.scoreString = distances
	}

	func distance(for time: Int, speed: Int) -> Int {
		return time * speed
	}

	func ranges(for time: Int, toBeat score: Int) -> Int {
		let timeRange = 1..<time
		let min = timeRange.first(where: { distance(for: time - $0, speed: $0) > score })!
		let max = timeRange.last(where: { distance(for: time - $0, speed: $0) > score })!
		return (max - min) + 1
	}

	func partOne() -> Int {
		let (times, scores) = [timeString, scoreString].map {
			$0.components(separatedBy: .whitespaces).compactMap(Int.init)
		}.firstTwoValues

		return zip(times, scores)
			.map { ranges(for: $0, toBeat: $1) }
			.filter { $0 > 0 }
			.reduce(1, *)
	}

	func partTwo() -> Int {
		let (time, score) =  [timeString, scoreString].map {
			$0.components(separatedBy: .whitespaces).joined()
		}
		.map { Int($0)! }
		.firstTwoValues
		return ranges(for: time, toBeat: score)
	}
}
