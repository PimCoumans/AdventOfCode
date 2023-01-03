import Foundation

fileprivate struct Valve: Identifiable, Hashable {
	let id: String
	let flowRate: Int
	let neighbors: Set<ID>

	var hasFlow: Bool { flowRate > 0 }
}

struct Day16: Day {

	let input: String
	init(input: String) {
		self.input = input
//		self.input = """
//Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
//Valve BB has flow rate=13; tunnels lead to valves CC, AA
//Valve CC has flow rate=2; tunnels lead to valves DD, BB
//Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
//Valve EE has flow rate=3; tunnels lead to valves FF, DD
//Valve FF has flow rate=0; tunnels lead to valves EE, GG
//Valve GG has flow rate=0; tunnels lead to valves FF, HH
//Valve HH has flow rate=22; tunnel leads to valve GG
//Valve II has flow rate=0; tunnels lead to valves AA, JJ
//Valve JJ has flow rate=21; tunnel leads to valve II
//"""
	}

	private func parseInput() -> [Valve] {
		let separatorCharacterSet: CharacterSet = .punctuationCharacters.union(.whitespaces).union(.symbols)
		return self.input
			.lines()
			.map { line in
				let words = line
					.components(separatedBy: separatorCharacterSet)
					.filter { !$0.isEmpty }
				return Valve(
					id:words[1],
					flowRate: words[5].toInt()!,
					neighbors: Set(words
						.suffix(from: 10)
						.map { String($0) })
				)
			}
	}
	
	func partOne() -> Int {
		let valveArray = parseInput()
		let valves = Dictionary(uniqueKeysWithValues: valveArray.map { ($0.id, $0) })
		
		let startingValve = valveArray.first(where: { $0.id == "AA" })!
		let path = startingValve.path(in: valves, multiplier: 30)

		return path.totalPressure
	}
	
	func partTwo() -> Int {
		0
	}
}

extension Valve {

	struct Path {
		let totalPressure: Int
		let valves: [Valve]
	}

	func path(in valves: [ID: Valve], multiplier: Int, excluding opened: Set<Valve> = []) -> Path {
		var pressure = flowRate * multiplier
		var path = [self]
		var opened = opened
		if hasFlow {
			opened.insert(self)
		}
		let options: [Path] = valves
			.values
			.filter(\.hasFlow)
			.filter { !opened.contains($0)}
			.compactMap { valve in
				let steps = distance(to: valve, in: valves) + 1
				let valveMultiplier = multiplier - steps
				guard valveMultiplier > 0 else {
					return nil
				}
				let path = valve.path(in: valves, multiplier: valveMultiplier, excluding: opened)
				if multiplier == 30 {
					print(path.valves.map(\.id))
				}
				return path
			}
			.sorted(by: \.totalPressure)

		if let bestPath = options.last {
			pressure += bestPath.totalPressure
			path += bestPath.valves
		}
		return Path(totalPressure: pressure, valves: path)
	}

	func distance(to targetValve: Valve, in valves: [ID: Valve]) -> Int {
		var distance = 0
		var visitedValves: Set<Valve> = []
		var visitingValves: Set<Valve> = [self]
		while visitedValves.count < valves.count {
			distance += 1
			visitingValves = Set(
				visitingValves
					.flatMap { $0.neighbors.compactMap { valves[$0] } }
					.filter { !visitedValves.contains($0) }
			).subtracting(visitedValves)
			if visitingValves.isEmpty {
				fatalError("Not good: no valves to visit")
			}
			if visitingValves.contains(targetValve) {
				return distance
			}
			visitedValves.formUnion(visitingValves)
		}
		fatalError("Not good: valve not found")
	}
}
