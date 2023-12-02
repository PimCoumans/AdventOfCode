import Foundation

struct Day2: Day {
	enum Color: String, Hashable {
		case red
		case green
		case blue
	}

	struct Game {
		let index: Int
		let counts: [Color: Int]
	}

	let limits: [Color: Int] = [
		.red: 12,
		.green: 13,
		.blue: 14
	]

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
//Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
//Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
//Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
//Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
//"""
	}

	func partOne() -> Int {
		input
			.linesByDroppingTrailingEmpty()
			.compactMap(Game.init(string:))
			.filter { $0.isPossibleWith(limits: limits) }
			.reduce(0, { $0 + $1.index })
	}

	func partTwo() -> Int {
		0
	}
}

extension Day2.Game {
	init?(string: String) {
		let (game, rounds) = string.split(separator: ":").firstTwoValues
		guard
			let intString = game.components(separatedBy: .whitespaces).last,
			let int = Int(intString)
		else {
			return nil
		}
		self.index = int
		let colors = rounds.split(separator: ";").flatMap { $0.split(separator: ",") }
		counts = colors.reduce(into: [:], { partialResult, colorCount in
			let (countString, colorString) = colorCount.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces).firstTwoValues
			guard let count = Int(countString), let color = Day2.Color(rawValue: colorString) else {
				return
			}
			partialResult[color] = max(partialResult[color, default: count], count)
		})
	}

	func isPossibleWith(limits: [Day2.Color: Int]) -> Bool {
		counts.allSatisfy { limits[$0.key]! >= $0.value }
	}
}
