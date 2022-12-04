import Algorithms

extension Collection where Index: BinaryInteger {
	/// Get tuple of first two values, error when not available
	var firstTwoValues: (first: Element, second: Element) {
		precondition(count >= 2)
		return (self[0], self[1])
	}
}

extension ClosedRange where Self: Collection, Element: Equatable {
	/// Convenience function to see if either ranges contains the other, wrapped in `if #available` with newer method used
	static func eitherContainsOther(_ lhs: ClosedRange<Bound>, _ rhs: ClosedRange<Bound>) -> Bool {
		if #available(macOS 13.0, *) {
			return lhs.contains(rhs) || rhs.contains(lhs)
		} else {
			return lhs.clamped(to: rhs) == lhs || rhs.clamped(to: lhs) == rhs
		}
	}
}

struct Day4: Day {
	
	let rangePairs: [(ClosedRange<Int>, ClosedRange<Int>)]
	
	let input: String
	init(input: String) {
		self.input = input
		self.rangePairs = input
			.split(separator: "\n")
			.map {
				$0
					.split(separator: ",")
					.map { rangeDescription in
						rangeDescription
							.split(separator: "-")
							.map { Int($0)! }
					}
					.map(\.firstTwoValues)
					.map { $0...$1 }
					.firstTwoValues
			}
	}
	
	func partOne() -> String {
		rangePairs
			.filter { ClosedRange.eitherContainsOther($0, $1) }
			.count
			.description
	}
	
	func partTwo() -> String {
		rangePairs
			.filter { $0.overlaps($1) }
			.count
			.description
	}
}
