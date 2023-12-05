import Foundation

struct Day5: Day {
	struct Map {
		struct Mapper {
			let sourceRange: Range<Int>
			let offset: Int

			init(rangeString: String) {
				let ints = rangeString.components(separatedBy: .whitespaces).map { Int($0)! }
				sourceRange = ints[1]..<(ints[1] + ints[2])
				offset = ints[0] - ints[1]
			}
		}
		let mappers: [Mapper]

		init(rangeStrings: [String]) {
			mappers = rangeStrings.map(Mapper.init(rangeString:))
		}

		func map(int: Int) -> Int {
			if let mapper = mappers.first(where: { $0.sourceRange.contains(int) }) {
				return int + mapper.offset
			}
			return int
		}
	}

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//seeds: 79 14 55 13
//
//seed-to-soil map:
//50 98 2
//52 50 48
//
//soil-to-fertilizer map:
//0 15 37
//37 52 2
//39 0 15
//
//fertilizer-to-water map:
//49 53 8
//0 11 42
//42 0 7
//57 7 4
//
//water-to-light map:
//88 18 7
//18 25 70
//
//light-to-temperature map:
//45 77 23
//81 45 19
//68 64 13
//
//temperature-to-humidity map:
//0 69 1
//1 0 69
//
//humidity-to-location map:
//60 56 37
//56 93 4
//"""
	}

	func partOne() -> Int {
		let blocks = self.input.lineBlocksByDroppingTrailingEmpty()
		var seeds = blocks.first!.first!
			.split(separator: ":").last!
			.components(separatedBy: .whitespaces)
			.compactMap(Int.init)

		let maps = blocks
			.dropFirst()
			.map { $0.dropFirst() }
			.map { Map(rangeStrings: Array($0)) }

		for map in maps {
			seeds = seeds.map { map.map(int: $0) }
		}
		return seeds.min()!
	}

	func partTwo() -> Int {
		0
	}
}
