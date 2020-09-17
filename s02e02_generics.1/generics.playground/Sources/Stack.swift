import Foundation

public struct Stack<Element> {
    private var storage: [Element] = []
    
    public init() {}
    
    public mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    @discardableResult
    public mutating func pop() -> Element? {
        return storage.popLast()
    }
    
    public func peek() -> Element? {
        storage.last
    }
    
}

extension Stack: CustomStringConvertible {
    public var description: String {
        """
        ----TOP----
        \(storage.map( { "\($0)" }).reversed().joined(separator: "\n"))
        ----END----
        """
    }
}
