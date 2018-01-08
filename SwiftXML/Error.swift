extension XML {
    
    // Error handling
    open enum XMLError: Error {
        
        case elementNotFound
        
        case rootElementMissing
        
        case parsingFailed
        
    }

}

