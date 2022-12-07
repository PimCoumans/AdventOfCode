import Foundation
import Algorithms

struct Day5: Day {

	struct Move {
		let amount: Int
		let fromStackIndex: Int
		let toStackIndex: Int
	}

	// Stacks with characters going from bottom to top, meaning last character is on top of the stack
	let stacks: [[Character]]
	let moves: [Move]

	let input: String
	init(input: String) {
		self.input = input
		let (stack, instructions) = input.components(separatedBy: "\n\n").firstTwoValues

		// Parse first part of input into stacks
		let stackRows = stack.split(separator: "\n").dropLast()
		let charLength = stackRows.map(\.count).max()!
		let numberOfStacks = (charLength + 1) / 4
		var stacks: [[Character]] = Array.init(repeating: [], count: numberOfStacks)

		let crateTrimCharacterSet = CharacterSet.whitespaces.union(.punctuationCharacters)
		for row in stackRows {
			for (index, crate) in row.chunks(ofCount: 4).enumerated() {
				let characters = crate.trimmingCharacters(in: crateTrimCharacterSet)
				guard let character = characters.first else {
					continue
				}
				stacks[index].insert(character, at: 0)
			}
		}
		self.stacks = stacks

		// Parse second part into move instructions
		self.moves = instructions.split(separator: "\n")
			.map { instruction in
				let indices = instruction
					.components(separatedBy: .whitespaces)
					.compactMap { Int($0) }
				guard indices.count == 3 else { fatalError() }
				return Move(
					amount: indices[0],
					fromStackIndex: indices[1] - 1,
					toStackIndex: indices[2] - 1
				)
			}
	}

	enum Crane {
		case crateMover9000
		case crateMover9001
		var canPickupMultipleCrates: Bool { self == .crateMover9001 }
	}

	func reorderedStacks(using crane: Crane) -> [[Character]] {
		var stacks = self.stacks
		for move in moves {
			var chunk: [Character] = stacks[move.fromStackIndex].suffix(move.amount)
			if !crane.canPickupMultipleCrates {
				chunk = chunk.reversed()
			}
			stacks[move.fromStackIndex].removeLast(move.amount)
			stacks[move.toStackIndex].append(contentsOf: chunk)
		}
		return stacks
	}
	
	func partOne() -> String {
		let stacks = reorderedStacks(using: .crateMover9000)
		let crates = stacks.compactMap(\.last)
		return String(crates)
	}
	
	func partTwo() -> String {
		let stacks = reorderedStacks(using: .crateMover9001)
		let crates = stacks.compactMap(\.last)
		return String(crates)
	}
}
