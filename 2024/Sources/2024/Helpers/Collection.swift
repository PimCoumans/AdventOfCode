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

	func appending(_ element: Element) -> [Element] {
		self + [element]
	}
}

extension Collection where Element: BinaryInteger {
	func sum() -> Element {
		reduce(0, +)
	}
	func product() -> Element {
		reduce(1, *)
	}
}

extension Collection {
	var isNotEmpty: Bool {
		!isEmpty
	}
}

extension Collection {

	public func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
		sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
	}

	func max<Value: Comparable>(_ keyPath: KeyPath<Element, Value>) -> Element? {
		self.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
	}
	func max<Value: Comparable>(_ keyPath: KeyPath<Element, Value>) -> Value? {
		map({ $0[keyPath: keyPath] }).max()
	}

	func min<Value: Comparable>(_ keyPath: KeyPath<Element, Value>) -> Element? {
		self.min(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
	}
	func min<Value: Comparable>(_ keyPath: KeyPath<Element, Value>) -> Value? {
		map({ $0[keyPath: keyPath] }).min()
	}
}

extension Collection where Element: Sequence {
	func mappedToArrays() -> [Array<Element.Element>] {
		map(Array.init(_:))
	}

	func mappedToSets() -> [Set<Element.Element>] where Element.Element: Hashable {
		map(Set.init(_:))
	}
}
