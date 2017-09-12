import Foundation

extension XML {
    
    open class Node {
        
        internal(set) weak var parent: Node?
        
        internal(set) var children = [Node]()
        
        var name: String
        var namespaceURI: String?
        var namespacePrefix: String?
        var qualifiedName: String?
        var content: String?
        
        var attributes: [String : String]
        
        public init(name: String,
                    value: String? = nil,
                    attributes: [String : String] = [String : String]()) {
            self.name = name
            self.content = value
            self.attributes = attributes
        }
        
        subscript(key: String) -> Node {
            return children.first(where: { $0.name == key })!
        }
        
        @discardableResult func addChild(_ child: Node) -> Node {
            child.parent = self
            children.append(child)
            return child
        }
        
        @discardableResult func addChild(name: String,
                                         value: String? = nil,
                                         attributes: [String : String] = [String : String]()) -> Node
        {
            let child = Node(name: name, value: value, attributes: attributes)
            return addChild(child)
        }
    }

}

