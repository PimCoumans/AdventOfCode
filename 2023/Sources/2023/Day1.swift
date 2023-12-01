import Foundation

struct Day1: Day {
	let numbers: [String: Int]

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//two1nine
//eightwothree
//abcone2threexyz
//xtwone3four
//4nineeightseven2
//zoneight234
//7pqrstsixteen
//"""
		var numbers = [String: Int]()
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .spellOut
		for int in 0...9 {
			numbers["\(int)"] = int
			numbers[numberFormatter.string(from: NSNumber(value: int))!] = int
		}
		self.numbers = numbers
	}

	func partOne() -> Int {
		input
			.lines()
			.map {
				String($0.first(where: { $0.isNumber })!) +
				String($0.last(where: { $0.isNumber })!)
			}
			.compactMap(Int.init)
			.sum()
	}

	func findInteger(in string: String, options: String.CompareOptions = []) -> Int? {
		let ranges = numbers.compactMap { string.range(of: $0.key, options: options) }
		let foundRange: Range<String.Index>! = options == .backwards ? ranges.max(\.upperBound) : ranges.min(\.lowerBound)
		return numbers[String(string[foundRange])]
	}

	func findCombinedInteger(in string: String) -> Int? {
		guard
			let firstInt = findInteger(in: string),
			let lastInt = findInteger(in: string, options: .backwards) else {
			return nil
		}
		return firstInt * 10 + lastInt
	}

	func partTwo() -> Int {
		input
			.lines()
			.compactMap(findCombinedInteger(in:))
			.sum()
	}
}
