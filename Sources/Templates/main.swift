import Foundation
import TemplatesCore

func printHelp() {
    let help = """
Usage: templates --source ${TEMPLATE_DIR} --output ${OUTPUT_DIR} --prefix ${PREFIX} --json ${REPLACE_JSON_STRING}

Options:
--source Templates directory
--output Output directory
--prefix Prefix string
--json Replace JSON String
"""
    print(help)
}

func main() {
    if CommandLine.arguments.contains("--help") {
        printHelp()
        return
    }
    
    let arguments = Arguments(arguments: CommandLine.arguments).parse()
    guard let source = arguments["source"],
        let output = arguments["output"],
        let prefix = arguments["prefix"],
        let jsonString = arguments["json"] else {
            print("Invalid arguments.")
            printHelp()
            return
    }
    
    let templates = Templates(source: source, output: output, prefix: prefix, jsonString: jsonString)
    do {
        try templates.perform()
    } catch {
        switch error {
        case TemplatesError.dataGetFailed:
            print("data get failed")
            exit(1)
        case TemplatesError.jsonConvertFailed:
            print("json convert failed")
            exit(1)
        default:
            print("unknown error", error)
            exit(1)
        }
    }
    print("Done!")
    exit(0)
}
main()
