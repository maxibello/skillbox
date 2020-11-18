import Foundation

public class Node<Value> {
    public var value: Value
    public var next: Node?
    
    public init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> " + String(describing: next)
    }
}

public struct LinkedList<Value> {
    public var head: Node<Value>?
    public var tail: Node<Value>?
    
    public init() {}
    
    public mutating func push(_ value: Value) {
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    
    public mutating func append(_ value: Value) {
        guard !isEmpty, let tail = tail else {
            push(value)
            return
        }
        tail.next = Node(value: value)
        self.tail = self.tail?.next
    }
    
    public mutating func pop() -> Value? {
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
    
    @discardableResult
    public mutating func removeLast() -> Value? {
        guard let head = head else {
            return nil
        }
        guard head.next != nil else {
            return pop()
        }
        
        var prev = head
        var current = head
        while let next = current.next {
            prev = current
            current = next
        }
        
        prev.next = nil
        tail = prev
        return current.value
    }
    
    public var isEmpty: Bool {
        head == nil
    }
    
    public func search(what: Value) -> Node<Value>? where Value: Comparable {
        for node in self {
            if node.value == what {
                return node
            }
        }
        return nil
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard !isEmpty else {
            return "Empty list"
        }
        return String(describing: head)
    }
}

public struct LinkedListIterator<T>: IteratorProtocol {
    public typealias Element = Node<T>
    private var currentNode: Element?
    
    fileprivate init(startNode: Element?) {
        currentNode = startNode
    }
    
    public mutating func next() -> LinkedListIterator.Element? {
        let node = currentNode
        currentNode = currentNode?.next
        
        return node
    }
}

extension LinkedList: Sequence {
    
    public typealias Iterator = LinkedListIterator<Value>
    
    public func makeIterator() -> LinkedList.Iterator {
        return LinkedListIterator(startNode: head)
    }
}
