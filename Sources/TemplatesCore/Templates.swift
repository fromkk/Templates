import Foundation

public enum TemplatesError: Error {
    case dataGetFailed
    case jsonConvertFailed
}

public final class Templates {
    let source: String
    let output: String
    let prefix: String
    let jsonString: String
    public init(source: String, output: String, prefix: String, jsonString: String) {
        self.source = source
        self.output = output
        self.prefix = prefix
        self.jsonString = jsonString
    }
    
    public func perform() throws {
        let sourceFiles = self.sourceFiles()
        try export(sourceFiles)
    }
    
    func sourceFiles() -> [String] {
        let sourcePath = self.sourcePath()
        return Documents.allFiles(in: sourcePath)
    }
    
    func sourcePath() -> String {
        guard !source.hasPrefix("/") else {
            return source
        }
        
        let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(source)
        return url.path
    }
    
    func export(_ sourceFiles: [String]) throws {
        guard let data = self.jsonString.data(using: .utf8) else {
            throw TemplatesError.dataGetFailed
        }
        
        let json: [String: String]
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
                throw TemplatesError.jsonConvertFailed
            }
            json = jsonObject
        } catch {
            throw error
        }
        
        let source = self.source.hasPrefix("/") ? self.source : URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(self.source).path
        let now = Date()
        for i in 0..<sourceFiles.count {
            let sourcePath = sourceFiles[i]
            let task = TemplateTask(source: source, sourcePath: sourcePath, output: output, prefix: prefix, json: json, now: now)
            do {
                try task.perform()
            } catch {
                throw error
            }
        }
    }
}
