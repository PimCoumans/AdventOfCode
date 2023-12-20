import Foundation

struct Day11: Day {

	let map: Map<Int>
	let expandedMap: Map<Int>

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//...#......
//.......#..
//#.........
//..........
//......#...
//.#........
//.........#
//..........
//.......#..
//#...#.....
//"""
		let rows = self.input.linesByDroppingTrailingEmpty()

		var verticalOffset: Int = 0
		var populatedColumns: Set<Int> = []
		var map = Map<Int>(width: rows.first!.count, height: rows.count * 2)
		var index: Int = 0

		for (y, row) in rows.enumerated() {
			if row.allSatisfy({ $0 == "." }) {
				verticalOffset += 1
				continue
			}
			let columns = row.enumerated().filter { $0.element != "." }.map(\.offset)
			populatedColumns.formUnion(columns)
			for x in columns {
				let point = Point(x: x, y: y + verticalOffset)
				map[point] = index
				index += 1
			}
		}
		self.map = map

		let unpopulatedColumns = Set(0..<map.width).subtracting(populatedColumns)
		let width = map.width + unpopulatedColumns.count

		var expandedMap = Map<Int>(width: width, height: rows.count + verticalOffset)
		for (point, index) in map {
			let horizontalOffset = unpopulatedColumns.filter { $0 <= point.x }.count
			let newPoint = Point(x: point.x + horizontalOffset, y: point.y)
			expandedMap[newPoint] = index
		}
		self.expandedMap = expandedMap
	}

	func partOne() -> Int {
		let galaxies: [(Point, Int)] = expandedMap.compactMap { point, index in
			index.map { (point, $0) }
		}

		var paired: Set<Int> = []
		var lengths: [Int] = []
		for (pointA, galaxyA) in galaxies {
			for (pointB, galaxyB) in galaxies {
				guard !paired.contains(galaxyB), pointB != pointA else { continue }
				lengths.append((pointA - pointB).manhattanLength)
			}
			paired.insert(galaxyA)
		}
		return lengths.sum()
	}

	func partTwo() -> Int {
		0
	}
}
