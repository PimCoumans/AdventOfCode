//
//  File.swift
//  
//
//  Created by Pim on 02/12/2022.
//

import Foundation

let input = puzzleInput
var days: [Day] = [
	Day1(input: input)
]

for (dayNumber, day) in days.enumerated() {
	print("⭐️ Day \(dayNumber + 1)")
	print("- Part one: \(day.partOne())")
	print("- Part two: \(day.partTwo())")
}
