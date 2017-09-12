import Foundation

extension XML {
    
    internal class Parser: NSObject, XMLParserDelegate {
        
        var namespaces = [String:String]()
        
        let document: XMLDocument
        let data: Data
        
        var currentParent: Node?
        var currentElement: Node?
        var currentValue = String()
        
        var parseError: XMLError?
        
        init(document: XMLDocument, data: Data) {
            self.document = document
            self.data = data
            currentParent = document
            
            super.init()
        }
        
        func parse() throws {
            let parser = XMLParser(data: data)
            parser.delegate = self
            
            parser.shouldProcessNamespaces = true
            parser.shouldReportNamespacePrefixes = true
            parser.shouldResolveExternalEntities = true
            
            let success = parser.parse()
            
            if !success {
                guard let error = parseError else { throw XMLError.parsingFailed }
                throw error
            }
        }
        
        // Does not guard against potential key collisions, nor if the : is the last char for some reason
        func removeNamespacePrefixFromAttributes(attributes: [String:String]) -> [String:String] {
            var cleanAttributes = [String:String]()
            for (key, value) in attributes {
                if key.contains(":")  {
                    cleanAttributes[String(key.split(separator: ":")[1])] = value
                } else {
                    cleanAttributes[key] = value
                }
            }
            return cleanAttributes
        }
        
        // XMLParserDelegate functions
        func parser(_ parser: XMLParser,
                    didStartElement elementName: String,
                    namespaceURI: String?,
                    qualifiedName qName: String?,
                    attributes attributeDict: [String : String])
        {
            
            currentValue = String()
            currentElement = currentParent?.addChild(name: elementName, attributes: removeNamespacePrefixFromAttributes(attributes: attributeDict))
            currentParent = currentElement
            currentElement?.namespaceURI = namespaceURI
            currentElement?.qualifiedName = qName
            
            if let nsURI = namespaceURI {
                currentElement?.namespacePrefix = namespaces[nsURI]
            }
        }
        
        // Do we really want to trim whitespace here? Consider removing this.
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            currentValue += string
            let newValue = currentValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            currentElement?.content = newValue == String() ? nil : newValue
        }
        
        func parser(_ parser: XMLParser,
                    didEndElement elementName: String,
                    namespaceURI: String?,
                    qualifiedName qName: String?)
        {
            currentParent = currentParent?.parent
            currentElement = nil
        }
        
        func parser(_ parser: XMLParser, parseErrorOccurred parseError: XMLError) {
            self.parseError = parseError
        }
        
        func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
            namespaces[namespaceURI] = prefix
        }
        
    }
}

