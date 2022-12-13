import Foundation

struct Map<Tile: Equatable> {
	var storage: [Point: Tile]

	let width: Int
	let height: Int

	init(width: Int, height: Int) {
		self.width = width
		self.height = height
		self.storage = [:]
	}
}

extension Map {
	mutating func clear(with value: Tile) {
		storage.removeAll()
		enumerate(width: width, height: height) { point, _ in
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
			var point = currentPoint ?? 
			var x = currentPoint?.x ?? 0
			var y = currentPoint?.y ?? 0
			if x == map.width - 1 {
				if y == map.height {
					return nil
				}
				y += 1
				x = 0
			} else {
				x += 1
			}
			if y == map.height - 1
		}
	}



}

extension Map {
	func enumerate(width: Int, height: Int, enumerator: (_ point: Point, _ value: Tile?) -> Void) {
		for y in 0..<height {
			for x in 0..<width {
				let point = Point(x: x, y: y)
				enumerator(point, storage[point])
			}
		}
	}
}
