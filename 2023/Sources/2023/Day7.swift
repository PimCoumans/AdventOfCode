import Foundation

struct Day7: Day {

	static let cardMap: [Character: Character] = [
		"2": "A",
		"3": "B",
		"4": "C",
		"5": "D",
		"6": "E",
		"7": "F",
		"8": "G",
		"9": "H",
		"T": "I",
		"J": "J",
		"Q": "K",
		"K": "L",
		"A": "M"
	]

	struct Hand {
		let cards: String
		let bid: Int
		var type: HandType?
	}
	let hands: [Hand]

	enum HandType: Int {
		case highCard
		case pair
		case twoPair
		case three
		case fullHouse
		case four
		case five
	}

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//32T3K 765
//T55J5 684
//KK677 28
//KTJJT 220
//QQQJA 483
//"""
		self.hands = self.input.linesByDroppingTrailingEmpty()
			.map { $0.components(separatedBy: .whitespaces).firstTwoValues}
			.map { hand, bid in
				let cards = hand.map { Self.cardMap[$0]! }
				return Hand(cards: String(cards), bid: Int(bid)!)
			}
	}

	func counts(for hand: String) -> [Character: Int] {
		hand.reduce(into: [:]) {
			$0[$1, default: 0] += 1
		}
	}

	func type(for hand: String) -> HandType? {
		let counts = counts(for: hand)
		let maxCount = counts.values.max()!
		switch (counts.count, maxCount) {
		case (1, _): return .five
		case (2, 4): return .four
		case (2, 3): return .fullHouse
		case (3, 3): return .three
		case (3, 2): return .twoPair // not sure here
		case (4, 2): return .pair
		case (5, _): return .highCard
		default: return nil
		}
	}

	func partOne() -> Int {
		let hands = self.hands.map {
			var hand = $0
			hand.type = type(for: hand.cards)
			return hand
		}.sorted {
			guard let leftType = $0.type, let rightType = $1.type else {
				return false
			}
			if leftType.rawValue < rightType.rawValue {
				return true
			} else if leftType.rawValue > rightType.rawValue {
				return false
			}
			return $0.cards < $1.cards
		}

		return hands.enumerated().map { index, hand in
			hand.bid * (index + 1)
		}.sum()
	}

	func partTwo() -> Int {
		0
	}
}
