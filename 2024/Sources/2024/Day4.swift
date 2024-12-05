import Foundation

struct Day4: Day {
	let input: String

	let map: Map<Character>

	init(input: String) {
		self.input = input
//		self.input = """
//MMMSXXMASM
//MSAMXMSMSA
//AMXSXMAAMM
//MSAMASMSMX
//XMASAMXAMM
//XXAMMXXAMA
//SMSMSASXSS
//SAXAMASAAA
//MAMMMXMMMM
//MXMXAXMASX
//"""
		let lines = self.input.linesByDroppingTrailingEmpty()
		var map = Map<Character>(width: lines[0].count, height: lines.count)

		for (y, line) in lines.enumerated() {
			for (x, character) in line.enumerated() {
				let point = Point(x: x, y: y)
				map[point] = character
			}
		}

		self.map = map
	}

	func partOne() -> Int {
		var startingCharacters: [Point] = []
		let sequence: [Character] = Array("XMAS")

		for (point, character) in map {
			if character == sequence.first {
				startingCharacters.append(point)
			}
		}

		var xmasCount: Int = 0
		for start in startingCharacters {
			directions: for point in map.points(surrounding: start) {
				let direction = point - start
				var offset = point
				for character in sequence.dropFirst() {
					guard map[offset] == character else {
						continue directions
					}
					offset += direction
				}
				xmasCount += 1
			}
		}
		return xmasCount
	}

	func partTwo() -> Int {
		var middleCharacters: [Point] = []
		let sequence: [Character] = Array("MAS")
		let middleCharacter: Character = "A"

		for (point, character) in map {
			if character == middleCharacter {
				middleCharacters.append(point)
			}
		}


		var succeededMap = Map<Character>(sizeFrom: map)

		var xmasCount: Int = 0
		cross: for start in middleCharacters {
			let surrounding = map.tiles(surrounding: start)
				.filter { $1 == sequence.first }
				.filter { abs($0.point.x - start.x) == 1 && abs($0.point.y - start.y) == 1 }
			guard surrounding.count == 2 else { continue }

			var visitedPoints: [(Point, Character)] = []

			for (point, _) in surrounding {
				let direction = start - point // flipped
				guard abs(direction.x) == 1 && abs(direction.y) == 1 else {
					continue
				}
				var offset = point
				for character in sequence {
					guard map[offset] == character else {
						continue cross
					}
					visitedPoints.append((offset, character))
					offset += direction
				}
			}

			for (point, character) in visitedPoints {
				succeededMap[point] = character
			}
			xmasCount += 1
		}
		return xmasCount
	}
}
