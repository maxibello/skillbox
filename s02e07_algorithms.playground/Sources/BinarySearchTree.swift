import Foundation

public class BinaryNode<Element> {
    public var value: Element
    public var leftChild: BinaryNode?
    public var rightChild: BinaryNode?
    public init(value: Element) {
        self.value = value
    }
}


extension BinaryNode: CustomStringConvertible {
    public var description: String {
        diagram(for: self)
    }
    private func diagram(for node: BinaryNode?,
                         _ top: String = "",
                         _ root: String = "",
                         _ bottom: String = "") -> String {
        guard let node = node else {
            return root + "nil\n"
        }
        if node.leftChild == nil && node.rightChild == nil {
            return root + "\(node.value)\n"
        }
        return diagram(for: node.rightChild,
                       top + " ", top + "┌──", top + "│ ")
            + root + "\(node.value)\n"
            + diagram(for: node.leftChild,
                      bottom + "│ ", bottom + "└──", bottom + " ")
    }
}

public struct BinarySearchTree<Element: Comparable> {
    public private(set) var root: BinaryNode<Element>?
    public init() {}
}
extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        guard let root = root else { return "empty tree" }
        return String(describing: root)
    }
}

extension BinarySearchTree {
    public mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }
    private func insert(from node: BinaryNode<Element>?, value:
                            Element)
    -> BinaryNode<Element> {
        // 1
        guard let node = node else {
            return BinaryNode(value: value)
        }
        // 2
        if value < node.value {
            node.leftChild = insert(from: node.leftChild, value:
                                        value)
        } else {
            node.rightChild = insert(from: node.rightChild, value:
                                        value)
        }
        // 3
        return node
    }
    
    public func search(_ value: Element) -> BinaryNode<Element>? {
        // 1
        var current = root
        // 2
        while let node = current {
            // 3
            if node.value == value {
                return node
            }
            // 4
            if value < node.value {
                current = node.leftChild
            } else {
                current = node.rightChild
            }
        }
        return nil
    }
}


