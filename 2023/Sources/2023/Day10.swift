import Foundation

struct Day10: Day {

	struct Tile: Equatable {
		let character: Character
		let a: Point
		let b: Point

		var connections: [Point] {
			return [a, b]
		}
	}

	let start: Point
	let map: Map<Tile>

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//7-F7-
//.FJ|7
//SJLL7
//|F--J
//LJ.LJ
//"""
		let lines = self.input.linesByDroppingTrailingEmpty()
		var map = Map<Tile>(width: lines.first!.count, height: lines.count)
		var start: Point = .zero
		for (y, line) in lines.enumerated() {
			for (x, character) in line.enumerated() {
				let point = Point(x: x, y: y)
				if let tile = Tile(from: character) {
					map[point] = tile
				} else if character == "S" {
					start = point
				}
			}
		}

		let (connectionA, connectionB) = map.tiles(surrounding: start)
			.filter { $1.connections.contains(start - $0) }
			.map { $0.point - start }
			.firstTwoValues
		map[start] = Tile(character: "S", a: connectionA, b: connectionB)

		self.start = start
		self.map = map
	}

	func partOne() -> Int {
		var distanceMap = Map<Int>(width: map.width, height: map.height)
		distanceMap[start] = 0

		var tileMap = Map<Character>(width: map.width, height: map.height)
		tileMap[start] = map[start]?.character

		for var currentPoint in map[start]!.connections.map({ start + $0 }) {
			var previousPoint = start
			var distance = 1
			while currentPoint != start, distance < 1_000_000 {
				if distanceMap[currentPoint] ?? .max > distance {
					distanceMap[currentPoint] = distance
				}

				let tile = map[currentPoint]!
				tileMap[currentPoint] = tile.legibleCharacter
				let (a, b) = (currentPoint + tile.a, currentPoint + tile.b)
				let nextPoint = a != previousPoint ? a : b
				previousPoint = currentPoint
				currentPoint = nextPoint
				distance += 1
			}
		}

		print(tileMap.description(emptyTile: " "))
		return distanceMap.storage.values.max()!
	}

	func partTwo() -> Int {
		0
	}
}

extension Day10.Tile {
	init?(from character: Character) {
		switch character {
		case "|": self.init(character: character, a: Point(x: 0, y: -1), b: Point(x: 0, y: 1))
		case "-": self.init(character: character, a: Point(x: -1, y: 0), b: Point(x: 1, y: 0))
		case "L": self.init(character: character, a: Point(x: 0, y: -1), b: Point(x: 1, y: 0))
		case "J": self.init(character: character, a: Point(x: -1, y: 0), b: Point(x: 0, y: -1))
		case "7": self.init(character: character, a: Point(x: -1, y: 0), b: Point(x: 0, y: 1))
		case "F": self.init(character: character, a: Point(x: 0, y: 1), b: Point(x: 1, y: 0))
		default: return nil
		}
	}

	var legibleCharacter: Character {
		switch character {
		case "|": "┃"
		case "-": "━"
		case "L": "┗"
		case "J": "┛"
		case "7": "┓"
		case "F": "┏"
		default: "S"
		}
	}
}

extension Day10.Tile: CustomStringConvertible {
	var description: String {
		return String(character)
	}
}
