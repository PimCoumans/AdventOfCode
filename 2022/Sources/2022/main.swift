import Foundation

var days: [any Day] = [
	Day1(),
	Day2(),
	Day3(),
	Day4(),
	Day5(),
	Day6(),
	Day7(),
	Day8(),
	Day9()
]

for (dayNumber, day) in days.enumerated() {
	print("⭐️ Day \(dayNumber + 1)")
	print("- Part one: \(day.partOne())")
	print("- Part two: \(day.partTwo())")
}
