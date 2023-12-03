import Foundation

struct Day3: Day {

	struct PartNumber {
		var value: Int = 0
		var points: [Point] = []

		mutating func addDigit(_ character: Character) {
			guard let int = Int(String(character)) else { return }
			value = (value * 10) + int
		}
	}

	enum Value {
		case number
		case gear
		case otherSymbol

		var isSymbol: Bool {
			if case .number = self {
				return false
			}
			return true
		}

		init?(character: Character) {
			switch (character.isNumber, character) {
			case (true, _): self = .number
			case (_, "*"): self = .gear
			case (_, "."): return nil
			default: self = .otherSymbol
			}
		}
	}

	let map: Map<Value>
	var partNumbers: [PartNumber] = []

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//467..114..
//...*......
//..35..633.
//......#...
//617*......
//.....+.58.
//..592.....
//......755.
//...$.*....
//.664.598..
//"""
		let lines = self.input.linesByDroppingTrailingEmpty()
		var map: Map<Value> = Map(width: lines.first!.count, height: lines.count)
		for (y, line) in lines.enumerated() {
			var currentPartNumber: PartNumber = PartNumber()
			for (x, character) in line.enumerated() {
				let point = Point(x: x, y: y)
				if character.isNumber {
					map[point] = .number
					currentPartNumber.addDigit(character)
					currentPartNumber.points.append(point)
				} else {
					if currentPartNumber.value > 0 {
						partNumbers.append(currentPartNumber)
						currentPartNumber = PartNumber()
					}
					map[point] = Value(character: character)
				}
			}
			if currentPartNumber.value > 0 {
				partNumbers.append(currentPartNumber)
			}
		}
		self.map = map
	}

	func pointsSurrounding(_ partNumber: PartNumber) -> Set<Point> {
		Set(
			partNumber.points.flatMap { map.points(surrounding: $0)}
		).subtracting(
			Set(partNumber.points)
		)
	}

	func partNumberHasSurroundingSymbols(_ partNumber: PartNumber) -> Bool {
		pointsSurrounding(partNumber).allSatisfy { map[$0]?.isSymbol != true }
	}

	func partOne() -> Int {
		partNumbers
			.filter(partNumberHasSurroundingSymbols)
			.map(\.value)
			.sum()
	}

	func partTwo() -> Int {
		let gearPoints: [Point] = map
			.filter { $0.tile == .gear }
			.map(\.point)

		var gearToParts: [Point: [PartNumber]] = [:]

		for partNumber in partNumbers {
			for point in pointsSurrounding(partNumber) {
				if gearPoints.contains(point) {
					gearToParts[point, default: []].append(partNumber)
				}
			}
		}

		return gearToParts
			.filter { $0.value.count == 2 }
			.map {
				let (first, second) = $0.value.map(\.value).firstTwoValues
				return first * second
			}
			.sum()
	}
}
