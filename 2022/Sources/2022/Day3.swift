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

fileprivate extension Collection where Element: BinaryInteger {
	func sum() -> Element {
		reduce(0, +)
	}
}

fileprivate extension Collection where Element: Sequence {
	func mapToArray() -> [Array<Element.Element>] {
		map(Array.init(_:))
	}
	
	func mapToSet() -> [Set<Element.Element>] where Element.Element: Hashable {
		map(Set.init(_:))
	}
}

struct Day3: Day {
	
	static let alphabet = "abcdefghijklmnopqrstuvwxyz"
	static let priorities: [Character] = Array([alphabet, alphabet.uppercased()].joined())
	
	func sharedCharacter(inSets setCollection: [Set<Character>]) -> Character? {
		setCollection
			.reduce(Set()) { partialResult, characters in
				partialResult.isEmpty ? characters : partialResult.intersection(characters)
			}.first
	}
	
	func priority(ofCharacter character: Character) -> Int {
		Day3.priorities.firstIndex(of: character)! + 1
	}
	
	let input: String
	init(input: String) {
		self.input = input
	}
	
	func partOne() -> String {
		let compartmentCount = 2
		let totalCount: Int = input
			.split(separator: "\n")
			.mapToArray()
			.map { $0
				.split(numberOfChunks: compartmentCount)
				.mapToSet()
			}
			.compactMap(sharedCharacter(inSets:))
			.map(priority(ofCharacter:))
			.sum()
		
		return String(totalCount)
	}
	
	func partTwo() -> String {
		let groupSize = 3
		let totalCount = input
			.split(separator: "\n")
			.chunks(ofCount: groupSize)
			.map { group in
				group
					.mapToSet()
			}
			.compactMap(sharedCharacter(inSets:))
			.map(priority(ofCharacter:))
			.sum()
		
		return String(totalCount)
	}
}
