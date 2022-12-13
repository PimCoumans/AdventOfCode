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

	func nextSteps(from point: Point) -> [Point] {
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
	}

	func partOne() -> Int {
		var distanceMap = Map<Int>(width: heightMap.width, height: heightMap.height)
		var nextSteps = Set([start])
		var step: Int = 0
		while !nextSteps.contains(end) {
			step += 1
			nextSteps = Set(
				nextSteps
					.flatMap { point in
						self.nextSteps(from: point)
							.filter {
								!distanceMap.storage.keys.contains($0) // not already visited
							}
							.filter {
								(heightMap[$0]! - heightMap[point]!) <= 1 // only climbing up
							}
					}
			)
			for point in nextSteps {
				distanceMap[point] = step
			}
		}

		return step
	}

	func partTwo() -> Int {
		var distanceMap = Map<Int>(width: heightMap.width, height: heightMap.height)
		var nextSteps = Set([end])
		var step: Int = 0
		while nextSteps.count > 0 && nextSteps.first(where: { heightMap[$0] == 0 }) == nil {
			step += 1
			nextSteps = Set(
				nextSteps
					.flatMap { point in
						self.nextSteps(from: point)
							.filter {
								!distanceMap.storage.keys.contains($0) // not already visited
							}
							.filter {
								(heightMap[$0]! - heightMap[point]!) >= -1 // only climbing down
							}
					}
			)
			for point in nextSteps {
				distanceMap[point] = step
			}
		}
		return step
	}
}

