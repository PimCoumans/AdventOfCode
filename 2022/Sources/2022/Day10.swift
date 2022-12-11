import Foundation
import Algorithms

struct Day10: Day {

	enum Instruction {
		case addX(Int)
		case noop

		init?(string: String) {
			let instruction = string.components(separatedBy: .whitespaces)
			guard let index = ["addx", "noop"].firstIndex(of: instruction[0]) else {
				return nil
			}
			if index == 0, let int = instruction.last.flatMap({ Int($0) }) {
				self = .addX(int)
			} else {
				self = .noop
			}
		}

		var cycles: Int {
			switch self {
			case .addX(_): return 2
			case .noop: return 1
			}
		}
	}

	let input: String
	let rowLength = 40
	let instructions: [Instruction]

	init(input: String) {
		self.input = input
		instructions = self.input
			.components(separatedBy: .newlines)
			.compactMap { Instruction(string: $0) }
	}

	typealias CycleCallback = (_ cycleIndex: Int, _ x: Int, _ pixelX: Int) -> Void

	func runCycles(pre: CycleCallback? = nil, post: CycleCallback? = nil) {
		var cycleIndex: Int = 0
		var x: Int = 1
		for instruction in instructions {
			for _ in 0..<instruction.cycles {
				pre?(cycleIndex, x, cycleIndex % rowLength)
				cycleIndex += 1
				post?(cycleIndex, x, cycleIndex % rowLength)
			}
			if case .addX(let int) = instruction {
				x += int
			}
		}
	}

	func partOne() -> Int {
		var sum: Int = 0
		runCycles(post: { cycle, x, pixelIndex in
			if cycle % rowLength == 20 {
				sum += cycle * x
			}
		})
		return sum
	}

	func partTwo() -> String {
		var output = ""
		runCycles(pre: { cycle, x, xPixel in
			if cycle % rowLength == 0 {
				output += "\n"
			}
			if (xPixel-1...xPixel+1) .contains(x) {
				output += "#"
			} else {
				output += "."
			}
		})
		return output
	}
}
