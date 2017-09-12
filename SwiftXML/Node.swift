import Foundation

extension XML {
    
    open class Node {
        
        internal(set) weak var parent: Node?
        
        public var children = [Node]()
        
        public var name: String
        public var namespaceURI: String?
        public var namespacePrefix: String?
        public var qualifiedName: String?
        public var content: String?
        
        public var attributes: [String : String]
        
        public init(name: String,
                    value: String? = nil,
                    attributes: [String : String] = [String : String]()) {
            self.name = name
            self.content = value
            self.attributes = attributes
        }
        
        public subscript(key: String) -> Node? {
            return children.first(where: { $0.name == key })
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

