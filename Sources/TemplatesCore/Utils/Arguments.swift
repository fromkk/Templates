import Foundation

/// get arguments to dictionary
public struct Arguments {
    private let prefix: String = "--"
    
    private let arguments: [String]
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    /// parse arguments to dictionary
    ///
    /// - Returns: [String: String]
    public func parse() -> [String: String] {
        var result: [String: String] = [:]
        
        arguments.enumerated().forEach { (argument) in
            let offset = argument.offset
            let element = argument.element
            
            if element.hasPrefix(prefix) {
                let key = self.key(with: element)
                if let value = self.value(for: offset) {
                    result[key] = value
                } else {
                    result[key] = ""
                }
            }
        }
        
        return result
    }
    
    /// get key name from raw key string
    ///
    /// - Parameter element: String
    /// - Returns: String
    private func key(with element: String) -> String {
        return element.replacingOccurrences(of: "^\(prefix)", with: "", options: [.regularExpression], range: element.startIndex..<element.endIndex)
    }
    
    /// get value for index
    ///
    /// - Parameter index: Int
    /// - Returns: String?
    private func value(for index: Int) -> String? {
        let nextIndex = index + 1
        guard arguments.indices.contains(nextIndex) else { return nil }
        return arguments[nextIndex]
    }
}
