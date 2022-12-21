import Foundation

fileprivate extension Map where Tile == Day14.Tile {
	func flipped() -> Self {
		var map = Map<Tile>(width: width, height: height)
		for (point, tile) in self {
			let flippedPoint = (point * Point(x: 1, y: -1)) + Point(x: 0, y: height)
			map[flippedPoint] = tile
		}
		return map
	}
}

struct Day14: Day {

	enum Tile: Equatable, CustomStringConvertible {
		case line
		case sand

		var description: String {
			switch self {
			case .line: return "🛑"
			case .sand: return "🌕"
			}
		}
	}
	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//498,4 -> 498,6 -> 496,6
//503,4 -> 502,4 -> 502,9 -> 494,9
//"""
	}

	func parseMap(heightExtension: Int = 0) -> (offset: Point, map: Map<Tile>) {
		let points = self.input
			.lines()
			.flatMap {
				$0
					.components(separatedBy: "->") // Create each point point string
					.map { $0.trimmingCharacters(in: .whitespaces) }
					.map { $0.split(separator: ",").toInts().firstTwoValues } // Get both int values
					.map { Point(x: $0.first, y: $0.second) } // Map to Point
					.windows(ofCount: 2) // Iterate over each point combination
					.map { $0.firstTwoValues } // Map to 'first' and 'second'
					.flatMap { line in
						// Create array of each point in line
						let lineLength = (line.second - line.first).length
						let step = (line.second - line.first).signum // Normalized direction of line
						return (0...lineLength).map {
							line.first + (step * $0) // Each point in the line
						}
					}
			}
		let offset = Point(x: points.min(\.x)!, y: 0) // Ignore any elements until offset
		let mapHeight: Int = points.max(\.y)! + 1 + heightExtension
		var map = Map<Tile>(
			width: points.max(\.x)! + 1,
			height: mapHeight
		)
		for point in points {
			map[point] = .line
		}
		return (offset, map)
	}

	func simulateSand(restAtBottom: Bool = false) -> Map<Tile> {
		var (offset, map) = parseMap(heightExtension: 1)

		let sandStart = Point(x: 500, y: 0)
		let fallSteps = [
			Vector(x: 0, y: 1),
			Vector(x: -1, y: 1),
			Vector(x: 1, y: 1)
		]
		var noMoreMovesLeft: Bool = false
		while !noMoreMovesLeft {
			var sandFoundRest = false
			var sandPosition: Point = sandStart
			while !sandFoundRest {
				var positions = fallSteps
					.lazy
					.map { sandPosition + $0 }
					.filter { map[$0] == nil }

				if restAtBottom {
					// Don't let sand fall of edge
					positions = positions
						.filter {
							$0.y < map.height
						}
				}

				let nextPosition = positions.first

				guard let nextPosition else {
					// No next position found, we resting
					sandFoundRest = true
					map[sandPosition] = .sand
					if sandPosition == sandStart {
						// it's full!
						noMoreMovesLeft = true
					}
					break
				}
				guard nextPosition.y < map.height else {
					// sand fell off bottom
					noMoreMovesLeft = true
					break
				}
				sandPosition = nextPosition
			}
		}

//		print(map.description(offset: offset, emptyTile: "◼️"))
		return map
	}
	
	func partOne() -> Int {
		simulateSand()
			.storage.values
			.filter { $0 == .sand }
			.count
	}
	
	func partTwo() -> Int {
		simulateSand(restAtBottom: true)
			.storage.values
			.filter { $0 == .sand }
			.count
	}
}
