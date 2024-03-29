import Foundation

struct Map<Tile: Equatable> {
	private(set) var storage: [Point: Tile]

	let width: Int
	let height: Int

	init(width: Int, height: Int) {
		self.width = width
		self.height = height
		self.storage = [:]
	}

	init<Other>(sizeFrom map: Map<Other>) {
		width = map.width
		height = map.height
		self.storage = [:]
	}

	func containsPoint(_ point: Point) -> Bool {
		(0..<width).contains(point.x) &&
		(0..<height).contains(point.y)
	}
}

extension Map: CustomStringConvertible {
	var description: String {
		self.description()
	}
	
	func description(offset: Point = .zero, separator: String = "", emptyTile: String = ".") -> String {
		var output = ""
		enumerateTiles(offset: offset) { point, tile in
			output += point.x == offset.x ? "\n" : separator
			output += tile.map { "\($0)" } ?? emptyTile
		}
		return output
	}
}

extension Map {
	subscript(_ point: Point) -> Tile? {
		get {
			storage[point]
		}
		set {
			storage[point] = newValue
		}
	}
}

extension Map {
	mutating func clear(with value: Tile) {
		storage.removeAll()
		enumeratePoints { point in
			storage[point] = value
		}
	}
}

extension Map: Sequence {
	func makeIterator() -> Iterator {
		Iterator(map: self)
	}

	struct Iterator: IteratorProtocol {
		let map: Map
		typealias Element = (point: Point, tile: Tile?)
		var currentPoint: Point?
		mutating func next() -> Element? {
			var point = (currentPoint ?? Point(x: -1, y: 0)) + Point(x: 1, y: 0)
			if point.x >= map.width {
				point.y += 1
				point.x = 0
				if point.y >= map.height {
					return nil
				}
			}
			currentPoint = point
			return (point, map.storage[point])
		}
	}
}

extension Map {
	func enumeratePoints(offset: Point = .zero, _ enumerator: (_ point: Point) -> Void) {
		for y in offset.y..<height {
			for x in offset.x..<width {
				enumerator(Point(x: x, y: y))
			}
		}
	}
	func enumerateTiles(offset: Point = .zero, _ enumerator: (_ point: Point, _ tile: Tile?) -> Void) {
		enumeratePoints(offset: offset) { point in
			enumerator(point, storage[point])
		}
	}
}

extension Map {
	func floodFill(from startPoint: Point, while predicate: (Point) -> Bool) {
		guard predicate(startPoint) else {
			return
		}
		var visited: Set<Point> = [startPoint]
		var visiting: Set<Point> = [startPoint]
		repeat {
			visiting = Set(visiting.flatMap { points(surrounding: $0) })
				.subtracting(visited)
			visited.formUnion(visiting)

			visiting = visiting.filter(predicate)
		} while !visiting.isEmpty
	}
}

extension Map {
	func points(surrounding point: Point) -> [Point] {
		[
			Point(x: -1, y: -1),
			Point(x: 0, y: -1),
			Point(x: 1, y: -1),
			Point(x: -1, y: 0),
			Point(x: 1, y: 0),
			Point(x: -1, y: 1),
			Point(x: 0, y: 1),
			Point(x: 1, y: 1)
		]
			.map { $0 + point }
			.filter(containsPoint)
	}
	func tiles(surrounding point: Point) -> [(point: Point, tile: Tile)] {
		points(surrounding: point)
			.compactMap { point in
				storage[point].map { (point, $0) }
			}
	}
}
