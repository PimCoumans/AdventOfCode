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
}

extension Map: CustomStringConvertible {
	var description: String {
		self.description()
	}
	
	func description(separator: String = "", emptyTile: String = ".") -> String {
		map { point, tile in
			(point.x == 0 ? "\n" : separator) + (tile.map { "\($0)" } ?? emptyTile)
		}.joined()
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
			var point = (currentPoint ?? .zero) + Point(x: 1, y: 0)
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
	func enumeratePoints(_ enumerator: (_ point: Point) -> Void) {
		for y in 0..<height {
			for x in 0..<width {
				enumerator(Point(x: x, y: y))
			}
		}
	}
	func enumerateTiles(_ enumerator: (_ point: Point, _ tile: Tile?) -> Void) {
		enumeratePoints { point in
			enumerator(point, storage[point])
		}
	}
}
