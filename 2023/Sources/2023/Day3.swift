import Foundation

struct Day3: Day {

	struct PartNumber {
		var value: Int = 0
		var points: [Point] = []
	}

	enum Value {
		case number
		case symbol
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
					currentPartNumber.value = (currentPartNumber.value * 10) + Int(String(character))!
					currentPartNumber.points.append(point)
				} else {
					if currentPartNumber.value > 0 {
						partNumbers.append(currentPartNumber)
						currentPartNumber = PartNumber()
					}
					if character != "." {
						map[point] = .symbol
					}
				}
			}
			if currentPartNumber.value > 0 {
				partNumbers.append(currentPartNumber)
			}
		}
		self.map = map
	}

	func partNumberHasSurroundingSymbols(_ partNumber: PartNumber) -> Bool {
		for point in partNumber.points {
			if map.tiles(surrounding: point).contains(.symbol) {
				return true
			}
		}
		return false
	}

	func partOne() -> Int {
		partNumbers
			.filter(partNumberHasSurroundingSymbols)
			.map(\.value)
			.sum()
	}

	func partTwo() -> Int {
		0
	}
}
