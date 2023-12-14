import Foundation
import OrderedCollections

struct Day8: Day {
	let input: String

	let instructions: [Int]
	let dictionary: OrderedDictionary<String, [String]>

	init(input: String) {
		self.input = input
		instructions = self.input.blocks().first!.map {
			switch $0 {
			case "L": return 0
			case "R": return 1
			default: fatalError()
			}
		}
		dictionary = OrderedDictionary(
			self.input
				.blocks()
				.last!
				.linesByDroppingTrailingEmpty()
				.map {
					let components = $0.components(separatedBy: .whitespaces)
					let key = components.first!
					let nodes = components.dropFirst(2).map {
						$0.trimmingCharacters(in: .alphanumerics.inverted)
					}
					return (key, nodes)
				},
			uniquingKeysWith: { $1 }
		)
	}

	func stepsToReach(from startKey: String, to targetPredicate: (String) -> Bool) -> Int {
		var currentKey = startKey
		var index = 0
		let max = 1_000_000
		while !targetPredicate(currentKey) && index < max {
			let instruction = instructions[index % instructions.count]
			currentKey = dictionary[currentKey]![instruction]
			index += 1
		}
		return index
	}

	func partOne() -> Int {
		stepsToReach(from: "AAA", to: { $0 == "ZZZ" })
	}

	func partTwo() -> Int {
		let startKeys = dictionary.keys.filter { $0.hasSuffix("A") }
		func isTarget(key: String) -> Bool { key.hasSuffix("Z") }

		let steps: [String: Int] = Dictionary(
			startKeys.map {
				let steps = stepsToReach(from: $0, to: { $0.hasSuffix("Z") })
				return ($0, steps / instructions.count)
			},
			uniquingKeysWith: { $1 }
		)
		return steps.values.product() * instructions.count
	}
}
