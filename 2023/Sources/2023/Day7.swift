import Foundation

struct Day7: Day {

	struct Hand: Comparable {
		var cards: String
		let bid: Int
		var type: HandType?

		static func < (left: Hand, right: Hand) -> Bool {
			if left.type!.rawValue < right.type!.rawValue {
				return true
			} else if left.type!.rawValue > right.type!.rawValue {
				return false
			}
			return left.cards < right.cards
		}
	}

	enum HandType: Int {
		case highCard
		case pair
		case twoPair
		case three
		case fullHouse
		case four
		case five
	}

	let cardMap: [Character: Character] = [
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

	let hands: [Hand]

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
				return Hand(cards: hand, bid: Int(bid)!)
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
		case (3, 2): return .twoPair
		case (4, 2): return .pair
		case (5, _): return .highCard
		default: return nil
		}
	}

	func highestType(for hand: String) -> HandType? {
		guard hand.contains("J") else {
			return type(for: hand)
		}
		let types = cardMap.keys.compactMap {
			return type(for: hand.replacingOccurrences(of: "J", with: String($0)))
		}
		return types.max(\.rawValue)
	}

	func partOne() -> Int {
		let hands = self.hands.map {
			var hand = $0
			hand.type = type(for: hand.cards)
			hand.cards = String(hand.cards.map { cardMap[$0]! })
			return hand
		}.sorted()

		return hands.enumerated().map { index, hand in
			hand.bid * (index + 1)
		}.sum()
	}

	func partTwo() -> Int {
		var cardMap = cardMap
		cardMap["J"] = "0"

		let hands = self.hands.map {
			var hand = $0
			hand.type = highestType(for: hand.cards)
			hand.cards = String(hand.cards.map { cardMap[$0]! })
			return hand
		}.sorted()

		return hands.enumerated().map { index, hand in
			hand.bid * (index + 1)
		}.sum()
	}
}
