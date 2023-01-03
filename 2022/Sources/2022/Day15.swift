import Foundation

fileprivate struct SensorArea {
	let point: Point
	let beacon: Point
	let radius: Int

	let horizontalRange: ClosedRange<Int>
	let verticalRange: ClosedRange<Int>

	init(point: Point, beacon: Point, radius: Int) {
		self.point = point
		self.beacon = beacon
		self.radius = radius
		self.horizontalRange = (point.x - radius)...(point.x + radius)
		self.verticalRange = (point.y - radius)...(point.y + radius)
	}

	func rangeContains(_ other: Point) -> Bool {
		let distance = (other - point).abs
		if distance.x > radius || distance.y > radius {
			return false
		}
		return distance.x + distance.y <= radius
	}
}

fileprivate enum Legend: CustomStringConvertible {
	case sensor
	case beacon
	case scanRange
	case empty

	var description: String {
		switch self {
		case .sensor: return "S"
		case .beacon: return "B"
		case .scanRange: return "#"
		case .empty: return "."
		}
	}
}

struct Day15: Day {

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//Sensor at x=2, y=18: closest beacon is at x=-2, y=15
//Sensor at x=9, y=16: closest beacon is at x=10, y=16
//Sensor at x=13, y=2: closest beacon is at x=15, y=3
//Sensor at x=12, y=14: closest beacon is at x=10, y=16
//Sensor at x=10, y=20: closest beacon is at x=10, y=16
//Sensor at x=14, y=17: closest beacon is at x=10, y=16
//Sensor at x=8, y=7: closest beacon is at x=2, y=10
//Sensor at x=2, y=0: closest beacon is at x=2, y=10
//Sensor at x=0, y=11: closest beacon is at x=2, y=10
//Sensor at x=20, y=14: closest beacon is at x=25, y=17
//Sensor at x=17, y=20: closest beacon is at x=21, y=22
//Sensor at x=16, y=7: closest beacon is at x=15, y=3
//Sensor at x=14, y=3: closest beacon is at x=15, y=3
//Sensor at x=20, y=1: closest beacon is at x=15, y=3
//"""
	}

	private func parseSensors() -> [SensorArea] {
		input
			.lines()
			.map {
				$0
					.components(separatedBy: ":")
					.map {
						$0
							.components(separatedBy: ",")
							.compactMap { $0.components(separatedBy: "=").last }
							.toInts()
							.firstTwoValues
					}
					.map {
						Point(x: $0, y: $1)
					}
					.firstTwoValues
			}
			.map {
				SensorArea(
					point: $0,
					beacon: $1,
					radius: ($1 - $0).manhattanLength
				)
			}
	}
	
	func partOne() -> Int {
		//		let checkedRow = 10
		let checkedRow = 2_000_000

		let sensors = parseSensors()

		let minX: Int = sensors.min(\.horizontalRange.lowerBound)!
		let maxX: Int = sensors.max(\.horizontalRange.upperBound)!
		let maxY: Int = sensors.max(\.verticalRange.upperBound)!

		var map = Map<Legend>(
			width: maxX + 1,
			height: maxY + 1)

		let overlappingSensors = sensors
			.filter { $0.verticalRange.contains(checkedRow) }

		for x in minX...maxX {
			let point = Point(x: x, y: checkedRow)
			guard let sensor = overlappingSensors
				.filter({ $0.horizontalRange.contains(x) })
				.first(where: { $0.rangeContains(point) }) else {
				continue
			}
			if point == sensor.point {
				map[point] = .sensor
			} else if point == sensor.beacon {
				map[point] = .beacon
			} else {
				map[point] = .scanRange
			}
		}

		return map.storage.keys
			.filter { $0.y == checkedRow }
			.compactMap { map[$0] }
			.filter { $0 == .scanRange }
			.count
	}
	
	func partTwo() -> Int {
//		let checkRange = 0...20
		let checkRange = 0...4_000_000

		let sensors = parseSensors()

		let minX: Int = sensors.min(\.horizontalRange.lowerBound)!
		let maxX: Int = sensors.max(\.horizontalRange.upperBound)!
		let minY: Int = sensors.min(\.verticalRange.lowerBound)!
		let maxY: Int = sensors.max(\.verticalRange.upperBound)!

		var map = Map<Legend>(
			width: maxX + 1,
			height: maxY + 1)

		let overlappingSensors = sensors
			.filter {
				checkRange.overlaps($0.verticalRange) &&
				checkRange.overlaps($0.horizontalRange)
			}

//		let verticalRange = (minY...maxY).clamped(to: checkRange)
		let horizontalRange = (minX...maxX).clamped(to: checkRange)

		for y in (minY...maxY).clamped(to: checkRange) {
			var x = horizontalRange.lowerBound
			while x <= horizontalRange.upperBound {
				defer {
					x += 1
				}
				let point = Point(x: x, y: y)
				guard let sensor = overlappingSensors.first(where: { $0.rangeContains(point )}) else {
					map[point] = .empty
					continue
				}

				let distance = sensor.point - point
				// Move x to end of scan area
				x = (sensor.point.x + sensor.radius) - abs(distance.y)
			}
		}

		return map.storage.keys
			.filter { map[$0] == .empty }
			.map { $0.x * 4_000_000 + $0.y }
			.first!
	}
}
