import Foundation
import Algorithms

struct Day12: Day {

	static let alphabet = Array("abcdefghijklmnopqrstuvwxyz")

	let heightMap: Map<Int>
	let start: Point
	let end: Point

	let input: String
	init(input: String) {
		self.input = input
		let data = input
			.lines()
			.mappedToArrays()
		let width = data.map(\.count).max()!
		let height = data.count
		var map = Map<Int>(width: width, height: height)
		var start: Point = .zero
		var end: Point = .zero
		var highest: Int = 0
		var lowest: Int = 0
		map.enumeratePoints { point in
			let letter = data[point.y][point.x]
			if let index = Day12.alphabet.firstIndex(of: letter) {
				highest = max(index, highest)
				lowest = min(index, lowest)
				map[point] = index
			} else if letter == "S" {
				start = point
			} else if letter == "E" {
				end = point
			}
		}
		map[start] = lowest
		map[end] = highest

		self.start = start
		self.end = end
		self.heightMap = map
	}

	func nextSteps(from point: Point) -> Set<Point> {
		Set(
			[
				Point(x: 0, y: -1),
				Point(x: 1, y: 0),
				Point(x: 0, y: 1),
				Point(x: -1, y: 0)
			]
				.map { point + $0 }
				.filter {
					(0..<heightMap.width).contains($0.x) &&
					(0..<heightMap.height).contains($0.y)
				}
		)
	}

	func numberOfSteps(from start: Point, heightRange: ClosedRange<Int>, until: (Point) -> Bool) -> Int {
		var nextSteps = Set([start])
		var visited = nextSteps
		var step: Int = 0
		while !nextSteps.isEmpty && nextSteps.first(where: until) == nil {
			step += 1
			nextSteps = Set(
				nextSteps
					.flatMap { point in
						self.nextSteps(from: point)
							.subtracting(visited)
							.filter {
								let difference = heightMap[$0]! - heightMap[point]!
								return heightRange.contains(difference)
							}
					}
			)
			visited.formUnion(nextSteps)
		}

		return step
	}

	func partOne() -> Int {
		numberOfSteps(from: start, heightRange: -2...1, until: { $0 == end })
	}

	func partTwo() -> Int {
		numberOfSteps(from: end, heightRange: -1...2, until: { heightMap[$0] == 0 })
	}
}

