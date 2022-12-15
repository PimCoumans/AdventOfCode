import Foundation
import Algorithms

fileprivate enum IntArray: CustomStringConvertible {
	case single(Int)
	indirect case array([IntArray])

	var array: [IntArray] {
		switch self {
		case .single(_): return [self]
		case .array(let array): return array
		}
	}

	var description: String {
		switch self {
		case .single(let int): return int.description
		case .array(let array): return "[" + array.map(\.description).joined(separator: ",") + "]"
		}
	}
}

extension IntArray {
	func result(comparing other: IntArray) -> ComparisonResult {
		if case .single(let int) = self, case .single(let otherInt) = other {
			if int == otherInt {
				return .orderedSame
			} else if int > otherInt {
				return .orderedDescending
			} else {
				return .orderedAscending
			}
		}

		let array = array
		let otherArray = other.array
		if array.isEmpty && otherArray.isEmpty {
			return .orderedSame
		}
		for (index, value) in array.enumerated() {
			if otherArray.count <= index {
				return .orderedDescending
			}
			let result = value.result(comparing: otherArray[index])
			if result != .orderedSame {
				return result
			}
		}
		if otherArray.count > array.count {
			return .orderedAscending
		}
		return .orderedSame
	}
}

struct Day13: Day {

	let input: String
	let arrayCharacters: [Character] = Array("[],")

	init(input: String) {
		self.input = input/*"""
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""*/
	}

	private func parseInput() -> [(first: IntArray, second: IntArray)] {
		self.input
			.components(separatedBy: "\n\n")
			.map {
				$0
					.lines()
					.prefix(2)
					.map {
						var string = String($0.dropFirst())
						return parseArrays(outOf: &string)
					}
					.firstTwoValues
			}
	}

	private func parseArrays(outOf string: inout String) -> IntArray {
		var intBuffer: String = ""
		var array: [IntArray] = []
		while !string.isEmpty {
			let character = string.removeFirst()
			if arrayCharacters.contains(character), let int = Int(intBuffer) {
				array.append(.single(int))
				intBuffer.removeAll()
			}

			switch character {
			case "[": array.append(parseArrays(outOf: &string))
			case "]": return .array(array)
			case ",": continue
			default: intBuffer.append(character)
			}
		}
		return .array(array)
	}

	func partOne() -> Int {
		parseInput()
			.enumerated()
			.filter {
				$1.first.result(comparing: $1.second) != .orderedDescending
			}
			.map(\.offset)
			.map { $0 + 1 }
			.reduce(0, +)
	}

	func partTwo() -> Int {
		0
	}
}
