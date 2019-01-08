import Foundation

enum TemplateTaskError: Error {
    case sourceNotFound
    case dataGetFailed
}

final class TemplateTask {
    let source: String
    let sourcePath: String
    let output: String
    let prefix: String
    let json: [String: String]
    let now: Date
    init(source: String, sourcePath: String, output: String, prefix: String, json: [String: String], now: Date) {
        self.source = source
        self.sourcePath = sourcePath
        self.output = output
        self.prefix = prefix
        self.json = json
        self.now = now
    }
    
    func perform() throws {
        var json = self.json
        if json["__PREFIX__"] == nil {
            json["__PREFIX__"] = prefix
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: now)
        if json["__YEAR__"] == nil {
            if let year = dateComponents.year {
                json["__YEAR__"] = String(format: "%04d", year)
            }
        }
        
        if json["__MONTH__"] == nil {
            if let month = dateComponents.month {
                json["__MONTH__"] = String(format: "%02d", month)
            }
        }
        
        if json["__DAY__"] == nil {
            if let day = dateComponents.day {
                json["__DAY__"] = String(format: "%02d", day)
            }
        }
        
        let outputPath = replace(
            source: URL(fileURLWithPath: output).appendingPathComponent(prefix).appendingPathComponent(sourcePath.replacingOccurrences(of: source, with: "")).path,
            json: json
        )
        let contents = try self.contents()
        let result = replace(source: contents, json: json)
        try write(result, to: outputPath)
    }
    
    func replace(source: String, json: [String: String]) -> String {
        return json.reduce(source, { (result, item) -> String in
            var result = result
            result = result.replacingOccurrences(of: item.key, with: item.value)
            return result
        })
    }
    
    func contents() throws -> String {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: sourcePath) else {
            throw TemplateTaskError.sourceNotFound
        }
        
        return try String(contentsOfFile: sourcePath)
    }
    
    func write(_ contents: String, to outputPath: String) throws {
        let fileManager = FileManager.default
        let fileName = URL(fileURLWithPath: outputPath).lastPathComponent
        let directory = outputPath.replacingOccurrences(of: fileName, with: "")
        try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        guard let data = contents.data(using: .utf8) else {
            throw TemplateTaskError.dataGetFailed
        }
        try data.write(to: URL(fileURLWithPath: outputPath))
    }
}
