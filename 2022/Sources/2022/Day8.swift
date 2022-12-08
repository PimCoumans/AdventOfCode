import Foundation
import Algorithms

struct Day8: Day {

	let width: Int
	let height: Int

	let heightMap: [Int]
	var visibilityMap: [Bool]

	let input: String
	init(input: String) {
		self.input = input

		let rows = self.input.components(separatedBy: .newlines)
		self.height = rows.count
		self.width = rows.first!.count
		heightMap = rows.flatMap { $0 }.compactMap { $0.wholeNumberValue }
		if heightMap.count != height * width {
			fatalError()
		}

		visibilityMap = Array.init(repeating: false, count: height * width)

		// Iterate over each row and then over each column in both directions
		for y in 0..<height {
			_ = (0..<width).reduce(-1) { tallestHeight, x in
				let height = heightMap[y * width + x]
				if height > tallestHeight {
					visibilityMap[y * width + x] = true
				}
				return max(height, tallestHeight)
			}

			_ = (0..<width).reversed().reduce(-1) { tallestHeight, x in
				let height = heightMap[y * width + x]
				if height > tallestHeight {
					visibilityMap[y * width + x] = true
				}
				return max(height, tallestHeight)
			}
		}

		// Iterate over each column and then over each row in both directions
		for x in 0..<width {
			_ = (0..<height).reduce(-1) { tallestHeight, y in
				let height = heightMap[y * width + x]
				if height > tallestHeight {
					visibilityMap[y * width + x] = true
				}
				return max(height, tallestHeight)
			}
			_ = (0..<height).reversed().reduce(-1) { tallestHeight, y in
				let height = heightMap[y * width + x]
				if height > tallestHeight {
					visibilityMap[y * width + x] = true
				}
				return max(height, tallestHeight)
			}
		}
	}

	func partOne() -> Int {
		for row in heightMap.chunks(ofCount: width) {
			print(row.map { String($0) }.joined(separator: " "))
		}
		for row in visibilityMap.chunks(ofCount: width) {
			print(row.map { $0 ? "x" : " "}.joined())
		}
		return visibilityMap.filter { $0 }.count
	}

	func partTwo() -> Int {

		var scoreMap: [Int] = Array.init(repeating: 0, count: width * height)
		for y in 0..<height {
			for x in 0..<width {
				let currentHeight = heightMap[y * width + x] - 1

				let rightRange = (x..<width).dropFirst()
				var score: Int = rightRange.enumerated().first { index, x in
					let height = heightMap[y * width + x]
					return height > currentHeight
				}.map { $0.offset + 1 } ?? rightRange.count

				let leftRange = (0..<x).reversed()
				score *= leftRange.enumerated().first { index, x in
					let height = heightMap[y * width + x]
					return height > currentHeight
				}.map { $0.offset + 1 } ?? leftRange.count

				let downRange = (y..<height).dropFirst()
				score *= downRange.enumerated().first { index, y in
					let height = heightMap[y * width + x]
					return height > currentHeight
				}.map { $0.offset + 1 } ?? downRange.count

				let upRange = (0..<y).reversed()
				score *= upRange.enumerated().first { index, y in
					let height = heightMap[y * width + x]
					return height > currentHeight
				}.map { $0.offset + 1 } ?? upRange.count

				scoreMap[y * width + x] = score
			}
		}
		for row in scoreMap.chunks(ofCount: width) {
			print(row.map { String(format: "%02 d", $0) }.joined(separator: " "))
		}
		return scoreMap.max()!
	}
}
