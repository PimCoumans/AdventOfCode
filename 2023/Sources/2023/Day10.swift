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
	var mainLoop: Map<Tile>

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//FF7FSF7F7F7F7F7F---7
//L|LJ||||||||||||F--J
//FL-7LJLJ||||||LJL-77
//F--JF--7||LJLJ7F7FJ-
//L---JF-JLJ.||-FJLJJ7
//|F|F-JF---7F7-L7L|7|
//|FFJF7L7F-JF7|JL---7
//7-L-JL7||F7|L7F-7F7|
//L.L7LFJ|||||FJL7||LJ
//L7JLJL-JLJLJL--JLJ.L
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
		map[start] = Tile(connections: (connectionA, connectionB))

		self.start = start
		self.map = map

		var mainLoop = Map<Tile>(width: map.width, height: map.height)
		mainLoop[start] = map[start]
		var previousPoint = start
		var currentPoint = start + map[start]!.a
		while currentPoint != start {
			let tile = map[currentPoint]!
			mainLoop[currentPoint] = tile
			let (a, b) = (currentPoint + tile.a, currentPoint + tile.b)
			let nextPoint = a != previousPoint ? a : b
			previousPoint = currentPoint
			currentPoint = nextPoint
		}
		self.mainLoop = mainLoop
	}

	func partOne() -> Int {
		var distanceMap = Map<Int>(width: map.width, height: map.height)
		distanceMap[start] = 0

		for var currentPoint in map[start]!.connections.map({ start + $0 }) {
			var previousPoint = start
			var distance = 1
			while currentPoint != start, distance < 1_000_000 {
				if distanceMap[currentPoint] ?? .max > distance {
					distanceMap[currentPoint] = distance
				}

				let tile = map[currentPoint]!
				let (a, b) = (currentPoint + tile.a, currentPoint + tile.b)
				let nextPoint = a != previousPoint ? a : b
				previousPoint = currentPoint
				currentPoint = nextPoint
				distance += 1
			}
		}

		return distanceMap.storage.values.max()!
	}

	func partTwo() -> Int {
		var outsideTiles = Map<Int>(width: map.width, height: map.height)
		outsideTiles.enumeratePoints { point in
			guard
				point.x == 0 || point.y == 0 || point.x == map.width - 1 || point.y == map.height - 1,
				outsideTiles[point] == nil,
				mainLoop[point] == nil
			else {
				return
			}
			mainLoop.floodFill(from: point) { point in
				guard mainLoop[point] == nil else {
					return false
				}
				outsideTiles[point] = 0
				return true
			}
		}

		var possibleInsideTiles = Map<Bool>(width: map.width, height: map.height)
		for (point, tile) in mainLoop {
			guard tile == nil, outsideTiles[point] == nil else { continue }
			possibleInsideTiles[point] = true
		}

		return possibleInsideTiles.storage.keys.filter {point in
			let anglesToPoint = (0..<point.x)
				.map { Point(x: $0, y: point.y) }
				.compactMap { mainLoop[$0] }
				.reduce(Float(0)) { count, tile in
					count + tile.horizontalAngle
				}
			return !Int(anglesToPoint).isMultiple(of: 2)
		}.count
	}
}

extension Day10.Tile {

	static let tileMap: [Character: (Point, Point)] = [
		"|": (Point(x: 0, y: -1), Point(x: 0, y: 1)),
		"-": (Point(x: -1, y: 0), Point(x: 1, y: 0)),
		"L": (Point(x: 0, y: -1), Point(x: 1, y: 0)),
		"J": (Point(x: -1, y: 0), Point(x: 0, y: -1)),
		"7": (Point(x: -1, y: 0), Point(x: 0, y: 1)),
		"F": (Point(x: 0, y: 1), Point(x: 1, y: 0))
	]

	init?(from character: Character) {
		guard let (a, b) = Self.tileMap[character] else {
			return nil
		}
		self.init(character: character, a: a, b: b)
	}

	init?(connections: (a: Point, b: Point)) {
		let flippedConnections = (connections.b, connections.a)
		guard
			let mappedTile = Self.tileMap.first(where: { $0.value == connections || $0.value == flippedConnections })
		else {
			return nil
		}
		self.init(character: mappedTile.key, a: mappedTile.value.0, b: mappedTile.value.1)
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

	var horizontalAngle: Float {
		switch character {
		case "|": 1
		case "-": 0
		case "F": 0.5
		case "J": 0.5
		case "L": -0.5
		case "7": -0.5
		default: 0
		}
	}
}

extension Day10.Tile: CustomStringConvertible {
	var description: String {
		return String(legibleCharacter)
	}
}
