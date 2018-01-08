extension XML {
    
    // Error handling
    enum XMLError: Error {
        
        case elementNotFound
        
        case rootElementMissing
        
        case parsingFailed
        
    }

}

