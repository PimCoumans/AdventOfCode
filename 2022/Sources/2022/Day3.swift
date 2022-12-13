import Foundation
import Algorithms

fileprivate extension Collection where Index: BinaryInteger, Index.Stride: BinaryInteger {
	func split(numberOfChunks chunkCount: Int) -> [SubSequence] {
		let chunkSize: Index = Index(count / chunkCount)
		return stride(from: startIndex, to: endIndex, by: Index.Stride(chunkSize)).map { index in
			self[index..<Swift.min(index + chunkSize, endIndex)]
		}
	}
}

fileprivate extension Collection where Element: Collection & SetAlgebra {
	var sharedIntersection: Element {
		reduceFromFirstElement { $0.intersection($1) }
	}
}

struct Day3: Day {
	
	static let alphabet = "abcdefghijklmnopqrstuvwxyz"
	static let priorities: [Character] = Array([alphabet, alphabet.uppercased()].joined())
	
	func priority(ofCharacter character: Character) -> Int {
		Day3.priorities.firstIndex(of: character)! + 1
	}
	
	let input: String
	init(input: String) {
		self.input = input
	}
	
	func partOne() -> Int {
		let compartmentCount = 2
		return input
			.split(separator: "\n")
			.mappedToArrays()
			.map { $0
				.split(numberOfChunks: compartmentCount)
				.mappedToSets()
			}
			.compactMap { $0.sharedIntersection.first }
			.map(priority(ofCharacter:))
			.sum()
	}
	
	func partTwo() -> Int {
		let groupSize = 3
		return input
			.split(separator: "\n")
			.chunks(ofCount: groupSize)
			.map { $0.mappedToSets() }
			.compactMap { $0.sharedIntersection.first }
			.map(priority(ofCharacter:))
			.sum()
	}
}
