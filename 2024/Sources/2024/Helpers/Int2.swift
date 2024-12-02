import Foundation

protocol Int2: Hashable, Comparable {
	var x: Int { get set }
	var y: Int { get set }

	init(x: Int, y: Int)

	static var zero: Self { get }
	static var one: Self { get }
}

struct Point: Int2 {

	var x, y: Int

	static let zero = Point(x: 0, y: 0)
	static let one = Point(x: 1, y: 1)

	static func < (lhs: Point, rhs: Point) -> Bool {
		(lhs - rhs).length < 0
	}
}

struct Vector: Int2 {
	var x, y: Int

	static let zero = Vector(x: 0, y: 0)
	static let one = Vector(x: 1, y: 1)

	static func < (lhs: Vector, rhs: Vector) -> Bool {
		(lhs - rhs).length < 0
	}
}

extension Int2 {

	static func < (lhs: Self, rhs: any Int2) -> Bool {
		(lhs - rhs).length < 0
	}

	static func + (left: Self, right: any Int2) -> Self {
		Self(x: left.x + right.x, y: left.y + right.y)
	}
	static func - (left: Self, right: any Int2) -> Self {
		Self(x: left.x - right.x, y: left.y - right.y)
	}
	static func / (left: Self, right: any Int2) -> Self {
		Self(
			x: right.x == 0 ? 0 : left.x / right.x,
			y: right.y == 0 ? 0 : left.y / right.y
		)
	}
	static func * (left: Self, right: any Int2) -> Self {
		Self(x: left.x * right.x, y: left.y * right.y)
	}

	static func += (left: inout Self, right: any Int2) {
		left = left + right
	}
	static func -= (left: inout Self, right: any Int2) {
		left = left - right
	}
	static func /= (left: inout Self, right: any Int2) {
		left = left / right
	}
	static func *= (left: inout Self, right: any Int2) {
		left = left * right
	}
}

extension Int2 {
	static func * (left: Self, right: Int) -> Self {
		left * Self(x: right, y: right)
	}
	static func / (left: Self, right: Int) -> Self {
		left / Self(x: right, y: right)
	}

	static func *= (left: inout Self, right: Int) {
		left = left * right
	}
	static func /= (left: inout Self, right: Int) {
		left = left * right
	}
}

extension Int2 {
	var length: Int { max(abs.x, abs.y) }

	var manhattanLength: Int { abs.x + abs.y }

	var abs: Self {
		Self(x: Swift.abs(x), y: Swift.abs(y))
	}

	var signum: Self { self / abs } // normalized values retaining sign
}
