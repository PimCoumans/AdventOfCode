import Foundation
import Algorithms

protocol Int2: Hashable {
	var x: Int { get set }
	var y: Int { get set }

	init(x: Int, y: Int)
}

extension Int2 {
	static func +(left: Self, right: any Int2) -> Self {
		Self(x: left.x + right.x, y: left.y + right.y)
	}
	static func -(left: Self, right: any Int2) -> Self {
		Self(x: left.x - right.x, y: left.y - right.y)
	}
	static func /(left: Self, right: any Int2) -> Self {
		Self(x: left.x / right.x, y: left.y / right.y)
	}

	static func +=(left: inout Self, right: any Int2) {
		left = left + right
	}

	var length: Int { max(abs.x, abs.y) }

	var abs: Self {
		Self(x: Swift.abs(x), y: Swift.abs(y))
	}

	var signum: Self { self / abs } // normalized values retaining sign

	var increments: [Self] {
		let step = Self(x: x / length, y: y / length)
		return Array.init(repeating: step, count: length)
	}
}

struct Day9: Day {

	struct Vector: Int2 {
		var x, y: Int
	}

	struct Point: Int2 {
		var x, y: Int
	}

	struct Map: CustomStringConvertible {
		var storage: [Point: Bool] = [:]
		var head: Point { didSet {
			storage[head] = storage[head, default: false]
			moveTail()
		}}
		var tail: [Point] { didSet {
			storage[tail.last!] = true
		}}

		init(head: Point, tailLength: Int = 1) {
			self.head = head
			self.tail = Array.init(repeating: head, count: tailLength)
			storage[head] = true
		}

		var min: Point {
			Point(
				x: storage.keys.map(\.x).min().map { $0 } ?? 0,
				y: storage.keys.map(\.y).min().map { $0 } ?? 0
			)
		}

		var max: Point {
			Point(
				x: storage.keys.map(\.x).max().map { $0 } ?? 0,
				y: storage.keys.map(\.y).max().map { $0 } ?? 0
			)
		}
		var width: ClosedRange<Int> {
			min.x...max.x
		}
		var height: ClosedRange<Int> {
			min.y...max.y
		}

		mutating func moveHead(vector: Vector) {
			head += vector
		}

		func tail(_ tail: Point, movedTowards destination: Point) -> Point {
			var difference = destination - tail
			var tail = tail
			while difference.length > 1 {
				if difference.abs.x > 0 && difference.abs.y > 0 {
					tail += difference.signum
				} else {
					tail += difference.increments.first!
				}
				difference = destination - tail
			}
			return tail
		}

		mutating func moveTail() {
			tail[0] = tail(tail[0], movedTowards: head)
			for index in tail.indices.dropFirst() {
				let lead = tail[index - 1]
				let follow = tail[index]
				tail[index] = tail(follow, movedTowards: lead)
			}

		}

		var description: String {
			var string = ""
			for y in height {
				for x in width {
					let point = Point(x: x, y: y)
					if point == head {
						string += "H"
					} else if let index = tail.firstIndex(of: point) {
						string += (index + 1).description
					}
					else {
						string += storage[Point(x: x, y: y), default: false] ? "o" : "."
					}
					string += ""
				}
				string += "\n"
			}
			return string
		}
	}

	let vectors: [Vector]

	let input: String
	init(input: String) {
		self.input = input/*"""
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""*/
		self.vectors = self.input
			.components(separatedBy: .newlines)
			.compactMap {
				let (first, second) = $0.components(separatedBy: .whitespaces).firstTwoValues
				guard let character = first.first, let length = Int(second) else {
					return nil
				}
				return Vector(character: character, length: length)
			}
	}

	func partOne() -> Int {
		var map = Map(head: Point(x: 0, y: 0))
//		print(map)
		for vector in vectors.flatMap(\.increments) {
			map.head += vector
//			print(map)
//			Thread.sleep(forTimeInterval: 0.05)
		}
//		print(map)
		return map.storage.values.filter { $0 }.count
	}

	func partTwo() -> Int {
		var map = Map(head: Point(x: 0, y: 0), tailLength: 9)
//		print(map)
		for vector in vectors.flatMap(\.increments) {
			map.head += vector
//			print(map)
//			Thread.sleep(forTimeInterval: 1)
		}
//		print(map)
		return map.storage.values.filter { $0 }.count
	}
}

extension Day9.Vector {
	init?(character: Character, length: Int) {
		switch character {
		case "R": self = Day9.Vector(x: length, y: 0)
		case "L": self = Day9.Vector(x: -length, y: 0)
		case "U": self = Day9.Vector(x: 0, y: -length)
		case "D": self = Day9.Vector(x: 0, y: length)
		default: return nil
		}
	}
}
