import Foundation

struct Day7: Day {

	enum Line {
		case goUp
		case goto(directory: String)
		case list // Unused

		case file(size: Int)
		case directory(name: String) // Unused

		init?(string: String) {
			let parts = string.components(separatedBy: .whitespaces)

			if parts.first == "$" {
				let command = parts[1]
				let parameter = parts.count > 2 ? parts[2] : nil
				switch (command, parameter) {
				case ("ls", .none): self = .list
				case ("cd", ".."): self = .goUp
				case ("cd", .some(let string)): self = .goto(directory: string)
				default: return nil
				}
			} else {
				let (description, name) = parts.firstTwoValues
				switch (description, name) {
				case ("dir", let name): self = .directory(name: name)
				case (let size, _) where Int(size) != nil: self = .file(size: Int(size)!)
				default: return nil
				}
			}
		}
	}

	let directorySizes: [Int]

	init(input: String) {

		var currentPath: [Int] = []
		var sizes: [Int] = []

		for line in input.components(separatedBy: .newlines) {
			switch Line(string: line) {
			case .goUp: // Leaving dir, add size to sizes
				sizes.append(currentPath.removeLast())
			case .goto(directory: _): // Entering dir, add new size to path
				currentPath.append(0)
			case .file(size: let fileSize): // Update all sizes in current path
				currentPath = currentPath.map { $0 + fileSize }
			default: continue
			}
		}

		sizes.append(contentsOf: currentPath)
		self.directorySizes = sizes
	}

	func partOne() -> Int {
		let maxSize = 100_000
		return directorySizes
			.filter { $0 <= maxSize }
			.reduce(0, +)
	}

	func partTwo() -> Int {
		let totalDiskSpace = 700_00_000
		let diskSpaceRequired = 300_00_000
		let diskSpaceFree = totalDiskSpace - directorySizes.max()!
		let spaceToDelete = diskSpaceRequired - diskSpaceFree
		return directorySizes
			.filter { $0 >= spaceToDelete }
			.min()!
	}
}
