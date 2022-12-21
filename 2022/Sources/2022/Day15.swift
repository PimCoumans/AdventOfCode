import Foundation

fileprivate struct SensorArea {
	let point: Point
	let beacon: Point
	let radius: Int

	var horizontalRange: ClosedRange<Int> {
		(point.x - radius)...(point.x + radius)
	}

	var verticalRange: ClosedRange<Int> {
		(point.y - radius)...(point.y + radius)
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
//							.map { $0.suffix(from: $0.index($0.startIndex, offsetBy: 2)) }
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
		let checkedRow = 2_000_000
//		let checkedRow = 10

		print("Parsing sensors")
		let sensors = parseSensors()

		print("Calculating bounds")
		let minX: Int = sensors.min(\.horizontalRange.lowerBound)!
		let maxX: Int = sensors.max(\.horizontalRange.upperBound)!
		let minY: Int = sensors.min(\.verticalRange.lowerBound)!
		let maxY: Int = sensors.max(\.verticalRange.upperBound)!
		

		var map = Map<Character>(
			width: maxX + 1,
			height: maxY + 1)

		print("Filtering sensors")

		let overlappingSensors = sensors
			.filter { $0.verticalRange.contains(checkedRow) }

		print("Enumerating row \(checkedRow), \(minX)...\(maxX)")

		let interval = 100_000
		for x in minX...maxX {
			if x % interval == 0 {
				print(String.init(repeating: ".", count: (x - minX) / interval))
			}
			let point = Point(x: x, y: checkedRow)
			let sensor = overlappingSensors.first { sensor in
				sensor.radius >= (sensor.point - point).manhattanLength
			}
			guard let sensor else {
				continue
			}
			if point == sensor.point {
				map[point] = "S"
			} else if point == sensor.beacon {
				map[point] = "B"
			} else {
				map[point] = "#"
			}
		}

		return map.storage.keys
			.filter { $0.y == checkedRow }
			.compactMap { map[$0] }
			.filter { $0 == "#" }
			.count
	}
	
	func partTwo() -> Int {
		0
	}
}
