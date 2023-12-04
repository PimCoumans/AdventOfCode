import Foundation

struct Day4: Day {
	struct Card {
		let winningCount: Int
		let points: Int

		init(string: String) {
			let (winning, drawn) = string
				.split(separator: "|")
				.map {
					$0.components(separatedBy: .whitespaces).compactMap(Int.init)
				}
				.mappedToSets()
				.firstTwoValues

			self.winningCount = winning.intersection(drawn).count
			if winningCount <= 1 {
				points = winningCount
			} else {
				let multiplier = winningCount - 1
				points = Int(pow(Float(2), Float(multiplier)))
			}
		}
	}

	let cards: [Card]
	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
//Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
//Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
//Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
//Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
//Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
//"""
		cards = self.input
			.linesByDroppingTrailingEmpty()
			.compactMap {
				$0
					.split(separator: ":")
					.last
			}
			.map(String.init)
			.map(Card.init(string:))
	}

	func partOne() -> Int {
		cards
			.map(\.points)
			.sum()
	}

	func grabCards(after cardNumber: Int, count: Int) -> [Card] {
		let range = cardNumber..<count
		let availableRange = 0..<cards.count
		let trimmedRange = range.clamped(to: availableRange)
		return Array(cards[trimmedRange])
	}

	func partTwo() -> Int {
		var cardArray = cards.map { [$0.winningCount] }
		for index in 0..<cardArray.count {
			for count in cardArray[index] {
				guard count > 0 else { break }
				let count = min(count, cardArray.count - index)
				for countIndex in (index + 1)...(index + count) {
					cardArray[countIndex].append(cards[countIndex].winningCount)
				}
			}
		}
		return cardArray.map(\.count).sum()
	}
}
