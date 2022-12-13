import Foundation

extension Collection {
	func reduceFromFirstElement(_ reducer: (Element, Element) -> Element) -> Element {
		dropFirst().reduce(first!, reducer)
	}
	/// Get tuple of first two values, error when not available
	var firstTwoValues: (first: Element, second: Element) {
		precondition(count >= 2)
		return (self[startIndex], self[index(after: startIndex)])
	}
}

extension Collection where Element: BinaryInteger {
	func sum() -> Element {
		reduce(0, +)
	}
}
