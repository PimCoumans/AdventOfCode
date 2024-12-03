import Foundation
import RegexBuilder

struct Day3: Day {
	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
//"""
	}

	let multiplicationsPattern = Regex {
		"mul("
		Capture {
			OneOrMore(.digit)
		} transform: { Int($0)! }
		","
		Capture {
			OneOrMore(.digit)
		} transform: { Int($0)! }
		")"
	}

	func partOne() -> Int {
		input.matches(of: multiplicationsPattern).map { $0.1 * $0.2 }.sum()
	}

	func partTwo() -> Int {
		let enabledMultiplicationsPattern = Regex {
			ZeroOrMore(.any, .reluctant)
			Optionally {
				"don't()"
				ZeroOrMore(.any, .reluctant)
				"do()"
				ZeroOrMore(.any, .reluctant)
			}
			multiplicationsPattern
		}
		return input.matches(of: enabledMultiplicationsPattern).map { $0.1 * $0.2 }.sum()
	}
}
