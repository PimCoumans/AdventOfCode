import Foundation

struct Day4: Day {
	let input: String

	let map: Map<Character>
	let startingCharacters: [Point]
	let sequence: [Character] = Array("XMAS")

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
		var startingCharacters: [Point] = []

		for (y, line) in lines.enumerated() {
			for (x, character) in line.enumerated() {
				let point = Point(x: x, y: y)
				map[point] = character
				if character == sequence.first {
					startingCharacters.append(point)
				}
			}
		}

		self.map = map
		self.startingCharacters = startingCharacters
	}

	func partOne() -> Int {
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
		0
	}
}
