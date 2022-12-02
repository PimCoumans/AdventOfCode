import XCTest
@testable import _022

class Day2Tests: XCTestCase {
	
	func testPartOneCompleteInput() {
		let input = self.input
		let lineCount = input.components(separatedBy: .newlines).count
		
		let day = Day2(input: input)
		let rounds = day.roundsFromMoves
		
		XCTAssertEqual(rounds.count, lineCount, "not all lines parsed into a round")
	}
	
	func testPartOneTotalScore() {
		let expectedScores = [
			2 + 6,
			1 + 0,
			3 + 3
		]
		let expectedTotalScore: Int = expectedScores.reduce(0, +)
		
		let day = Day2(input: input)
		let rounds = day.roundsFromMoves
		
		for (expectedScore, round) in zip(expectedScores, rounds) {
			XCTAssertEqual(expectedScore, round.score, "incorrect round score")
		}
		
		let totalScore = day.totalScore(for: rounds)
		XCTAssertEqual(totalScore, expectedTotalScore, "incorrect total score")
	}
	
	func testPartOneFirstRound() {
		let day = Day2(input: input)
		let rounds = day.roundsFromMoves
		let firstRound = rounds.first!
		
		XCTAssertNotNil(firstRound, "day should contain at least some rounds")
		
		XCTAssertEqual(firstRound, Day2.Round(opponent: .rock, player: .paper), "first round not parsed to expected outcome")
		XCTAssertEqual(firstRound.score, 2 + 6, "first round's score not correct")
	}
	
	func testPartTwoCompleteInput() {
		let input = self.input
		let lineCount = input.components(separatedBy: .newlines).count
		
		let day = Day2(input: input)
		let rounds = day.roundsFromOutcomes
		
		XCTAssertEqual(rounds.count, lineCount, "not all lines parsed into a round")
	}
	
	func testPartTwoTotalScore() {
		let expectedScores = [
			1 + 3,
			1 + 0,
			1 + 6
		]
		let expectedTotalScore: Int = expectedScores.reduce(0, +)
		
		let day = Day2(input: input)
		let rounds = day.roundsFromOutcomes
		
		for (expectedScore, round) in zip(expectedScores, rounds) {
			XCTAssertEqual(expectedScore, round.score, "incorrect round score")
		}
		
		let totalScore = day.totalScore(for: rounds)
		XCTAssertEqual(totalScore, expectedTotalScore, "incorrect total score")
	}
	
	func testPartOneMovesFirstRound() {
		let day = Day2(input: input)
		let rounds = day.roundsFromOutcomes
		let firstRound = rounds.first!
		
		XCTAssertNotNil(firstRound, "day should contain at least some rounds")
		XCTAssertEqual(firstRound.outcome, .draw, "first rounds does not have expected outcome")
		XCTAssertEqual(firstRound, Day2.Round(opponent: .rock, player: .rock), "first round not parsed to expected outcome")
		XCTAssertEqual(firstRound.score, 1 + 3, "first round's score not correct")
	}
}

extension Day2Tests {
	var input: String { """
A Y
B X
C Z
"""}
}
