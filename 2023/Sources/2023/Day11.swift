import Foundation

struct Day11: Day {

	let galaxies: [(point: Point, offset: Point)]

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
		let columnCount = rows.first!.count
		var populatedColumns: Set<Int> = []

		var galaxies: [(point: Point, offset: Point)] = []
		for (y, row) in rows.enumerated() {
			if row.allSatisfy({ $0 == "." }) {
				verticalOffset += 1
				continue
			}
			let columns = row.enumerated().filter { $0.element != "." }.map(\.offset)
			populatedColumns.formUnion(columns)
			for x in columns {
				galaxies.append((Point(x: x, y: y), Point(x: 0, y: verticalOffset)))
			}
		}

		let unpopulatedColumns = Set(0..<columnCount).subtracting(populatedColumns)
		self.galaxies = galaxies.map { point, offset in
			let horizontalOffset = unpopulatedColumns.filter { $0 <= point.x }.count
			return (point, offset + Point(x: horizontalOffset, y: 0))
		}
	}

	private func sumOfDistancesBetween(galaxies: [(point: Point, index: Int)]) -> Int {
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

	func partOne() -> Int {
		let galaxies: [(point: Point, index: Int)] = galaxies.enumerated().map { index, element in
			let (point, offset) = element
			return (point + offset, index)
		}
		return sumOfDistancesBetween(galaxies: galaxies)
	}

	func partTwo() -> Int {
		let multiplier = 1_000_000
		let galaxies: [(point: Point, index: Int)] = galaxies.enumerated().map { index, element in
			let (point, offset) = element
			let multipliedOffset = offset * (multiplier - 1)
			return (point + multipliedOffset, index)
		}
		return sumOfDistancesBetween(galaxies: galaxies)
	}
}
