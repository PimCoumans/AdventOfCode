import Foundation

protocol ScoreProviding {
	var score: Int { get }
}

struct Day2: Day {
	
	enum Move {
		case rock
		case paper
		case scissor
		
		static let winningMoves: [(winning: Move, losing: Move)] = [
			(.rock, .scissor),
			(.paper, .rock),
			(.scissor, .paper)
		]
	}
	
	struct Round: Equatable {
		enum Outcome {
			case lose
			case draw
			case win
		}
		
		let opponent: Move
		let player: Move
		let outcome: Outcome
	}
	
	let parsedLetters: [(opponent: String, player: String)]
	
	init(input: String) {
		self.parsedLetters = input
			.components(separatedBy: .newlines)
			.map { $0.components(separatedBy: .whitespaces) }
			.map { ($0[0], $0[1]) }
	}
	
	func partOne() -> Int {
		totalScore(for: roundsFromMoves)
	}
	
	func partTwo() -> Int {
		totalScore(for: roundsFromOutcomes)
	}
}

// MARK: Round parsing
extension Day2 {
	
	func totalScore(for rounds: [Round]) -> Int {
		rounds.map(\.score).reduce(0, +)
	}
	
	/// Rounds parsed as though the second letter means a specific move
	var roundsFromMoves: [Round] {
		parsedLetters
			.compactMap { opponentLetter, playerLetter in
				guard let opponentMove = Move(moveLetter: opponentLetter),
					  let playerMove = Move(moveLetter: playerLetter) else {
					return nil
				}
				return Round(opponent: opponentMove, player: playerMove)
			}
	}
	
	/// Rounds parsed as though the second letter means a specific outcome
	var roundsFromOutcomes: [Round] {
		parsedLetters
			.compactMap { opponentLetter, outcomeLetter in
				guard let opponentMove = Move(moveLetter: opponentLetter),
					  let outcome = Round.Outcome(outcomeLetter: outcomeLetter) else {
					return nil
				}
				return Round(opponent: opponentMove, outcome: outcome)
			}
	}
}

extension Day2.Move {
	static func winningMove(against opponent: Day2.Move) -> Day2.Move {
		Self.winningMoves.first(where: { $0.losing == opponent })!.winning
	}
	
	static func losingMove(against opponent: Day2.Move) -> Day2.Move {
		Self.winningMoves.first(where: { $0.winning == opponent })!.losing
	}
}

// MARK: Outcome deciding
extension Day2.Round {
	
	// Decide round on opponent and player moves
	init(opponent: Day2.Move, player: Day2.Move) {
		self.opponent = opponent
		self.player = player
		if opponent == player {
			self.outcome = .draw
		} else if Day2.Move.winningMove(against: opponent) == player {
			self.outcome = .win
		} else {
			self.outcome = .lose
		}
	}
	
	// Decide round on opponent move and player outcome
	init(opponent: Day2.Move, outcome: Day2.Round.Outcome) {
		self.opponent = opponent
		self.outcome = outcome
		
		switch outcome {
		case .draw:
			self.player = opponent
		case .win:
			self.player = Day2.Move.winningMove(against: opponent)
		case .lose:
			self.player = Day2.Move.losingMove(against: opponent)
		}
	}
}

// MARK: Move initializer
extension Day2.Move: CaseIterable {
	
	static let opponentMoves: [String: Day2.Move] = [
		"A": .rock,
		"B": .paper,
		"C": .scissor
	]
	
	static let playerMoves: [String: Day2.Move] = [
		"X": .rock,
		"Y": .paper,
		"Z": .scissor
	]
	
	init?(moveLetter letter: String) {
		guard let move = Self.opponentMoves[letter] ?? Self.playerMoves[letter] else {
			return nil
		}
		self = move
	}
}

// MARK: Outcome initializer
extension Day2.Round.Outcome: CaseIterable {
	static let outcomes : [String: Day2.Round.Outcome] = [
		"X": .lose,
		"Y": .draw,
		"Z": .win
	]
	
	init?(outcomeLetter letter: String) {
		guard let outcome = Self.outcomes[letter] else {
			return nil
		}
		self = outcome
	}
}

// MARK: - Score providing
extension Day2.Round: ScoreProviding {
	var score: Int {
		outcome.score + player.score
	}
}

extension Day2.Round.Outcome: ScoreProviding {
	var score: Int {
		switch self {
		case .lose: return 0
		case .draw: return 3
		case .win: return 6
		}
	}
}

extension Day2.Move: ScoreProviding {
	var score: Int {
		switch self {
		case .rock: return 1
		case .paper: return 2
		case .scissor: return 3
		}
	}
}
