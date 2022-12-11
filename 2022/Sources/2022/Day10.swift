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
	let instructions: [Instruction]

	init(input: String) {
		self.input = input
		instructions = self.input
			.components(separatedBy: .newlines)
			.compactMap { Instruction(string: $0) }
	}

	func partOne() -> Int {
		var cycle: Int = 0
		var x: Int = 1
		var sum: Int = 0
		for instruction in instructions {
			for _ in 0..<instruction.cycles {
				cycle += 1
				if (cycle + 20) % 40 == 0 {
					sum += cycle * x
				}
			}
			if case .addX(let int) = instruction {
				x += int
			}
		}
		return sum
	}

	func partTwo() -> String {
		let rowLength = 40
		var cycle: Int = 0
		var x: Int = 1
		var pixels: Set<Int> = []

		for instruction in instructions {
			for _ in 0..<instruction.cycles {
				let xPixel = cycle % rowLength
				if xPixel >= x - 1 && xPixel <= x + 1 {
					pixels.insert(cycle)
				}
				cycle += 1
			}
			if case .addX(let int) = instruction {
				x += int
			}
		}
		var output = ""
		for index in 0...pixels.max()! {
			if index % rowLength == 0 {
				output += "\n"
			}
			output += pixels.contains(index) ? "#" : "."
		}
		return output
	}
}
