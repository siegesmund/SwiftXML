extension XML {
    
    // Error handling
    public enum XMLError: Error {
        
        case elementNotFound
        
        case rootElementMissing
        
        case parsingFailed
        
    }

}

