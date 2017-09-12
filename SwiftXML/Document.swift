import Foundation

open class XML {
    
    open class Document {
        
        var document: XMLDocument!
        
        // Open with a url
        public init(url: String) throws {
            document = nil
            if let u = URL(string: url) {
                document = try fetchDocument(url: u)
            }
        }
        
        // Open a local file
        public init(filePath: String) throws {
            let u = URL(fileURLWithPath: filePath)
            document = try fetchDocument(url: u)
        }
        
        func fetchDocument(url: URL) throws -> XMLDocument? {
            if let data = try? Data(contentsOf: url)
            {
                let xmlDoc = try XMLDocument(xml: data)
                return xmlDoc
            }
            return nil
        }
    }
    
    
    public class XMLDocument: Node {
        
        var root: Node {
            return children.first!
        }
        
        public init(root: Node? = nil) {
            
            let documentName = String(describing: XMLDocument.self)
            super.init(name: documentName)
            
            // document has no parent element
            parent = nil
            
            // add root element to document (if any)
            if let rootElement = root {
                _ = addChild(rootElement)
            }
        }
        
        public convenience init(xml: Data) throws {
            self.init()
            try loadXML(xml)
        }
        
        internal func loadXML(_ data: Data) throws {
            children.removeAll(keepingCapacity: false)
            let xmlParser = Parser(document: self, data: data)
            try xmlParser.parse()
        }
        
    }

}


