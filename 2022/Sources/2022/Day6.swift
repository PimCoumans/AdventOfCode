import Foundation
import Algorithms

extension Collection where Element: Hashable {
	var isUnique: Bool {
		Set(self).count == count
	}
}

struct Day6: Day {

	let input: String
	init(input: String) {
		self.input = input
	}

	func indexAfterUniqueSequence(ofLength length: Int, in string: String) -> Int? {
		var markerSequence: [Character] = []
		return string
			.enumerated()
			.first { index, character in
				markerSequence.append(character)
				guard markerSequence.count > length else {
					return false
				}
				markerSequence.removeFirst()
				return markerSequence.isUnique
			}
			.map(\.offset)
			.map { $0 + 1 }
	}
	
	func partOne() -> Int {
		indexAfterUniqueSequence(ofLength: 4, in: input)!
	}
	
	func partTwo() -> Int {
		indexAfterUniqueSequence(ofLength: 14, in: input)!
	}
}
