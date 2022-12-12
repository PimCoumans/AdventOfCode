import Foundation
import Algorithms

extension Collection where Index: BinaryInteger {
	/// Get tuple of first two values, error when not available
	var lastTwoValues: (secondLast: Element, last: Element) {
		let values = reversed().firstTwoValues
		return (secondLast: values.second, last: values.first)
	}
}

extension StringProtocol {
	func toInt() -> Int? {
		return Int(self)
	}
}

extension Array where Element: StringProtocol {
	func toInts() -> [Int] {
		compactMap { $0.toInt() }
	}
}

struct Day11: Day {

	struct Monkey {
		var items: [Int]
		let operation: (Int) -> Int
		let moduloCheck: Int
		let targetMonkey: [Bool: Int]
		var inspectCount: Int = 0

		init?(string: String) {
			let rules = string.trimmedLines()

			self.items = rules[1]
				.split(separator: ":")
				.last!
				.split(separator: ",")
				.map { $0.trimmingCharacters(in: .whitespaces) }
				.toInts()
			let operation = rules[2]
				.elements()
				.lastTwoValues
			let value = operation.last.toInt()
			self.operation = {
				let multiplier = value ?? $0
				if operation.secondLast == "*" {
					return $0 * multiplier
				} else {
					return $0 + multiplier
				}
			}
			self.moduloCheck = rules[3]
				.components(separatedBy: .whitespaces)
				.last!
				.toInt()!
			self.targetMonkey = [
				true: rules[4].elements().last!.toInt()!,
				false: rules[5].elements().last!.toInt()!
			]
		}
	}

	let monkeys: [Monkey]
	let commonDenominator: Int
	let input: String
	init(input: String) {
		self.input = input /*"""
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""*/
		self.monkeys = self.input
			.blocks()
			.compactMap { Monkey(string: $0) }
		self.commonDenominator = monkeys.map(\.moduloCheck).reduceFromFirstElement(*)
	}

	func monkeyBusiness(round: Int, worryDivider: (Int) -> Int) -> Int {
		var monkeys = self.monkeys
		for _ in 0..<round {
			for monkeyIndex in 0..<monkeys.count {
				var monkey = monkeys[monkeyIndex]
				monkey.inspectCount += monkey.items.count
				for item in monkey.items {
					let level = worryDivider(monkey.operation(item))
					let targetMonkeyIndex = monkey.targetMonkey[level % monkey.moduloCheck == 0]!
					var targetMonkey = monkeys[targetMonkeyIndex]
					targetMonkey.items.append(level)
					monkeys[targetMonkeyIndex] = targetMonkey
				}
				monkey.items.removeAll()
				monkeys[monkeyIndex] = monkey
			}
		}

		return monkeys
			.map(\.inspectCount)
			.max(count: 2)
			.reduceFromFirstElement(*)
	}

	func partOne() -> Int {
		monkeyBusiness(round: 50, worryDivider: { $0 / 3 } )
	}

	func partTwo() -> Int {
		monkeyBusiness(round: 10_000, worryDivider: { $0 % commonDenominator })
	}
}
