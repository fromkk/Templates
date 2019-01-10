import Foundation
import TemplatesCore

func printHelp() {
    let help = """
# Configure
Usage: templates set --key ${KEY} --value ${VALUE}

Options:
--key Key string
--value Value string

# Remove key
Usage: templates remove --key ${KEY}

Options:
--key Key string

# Show
Usage: templates show --key ${KEY}

Options:
--key Key string(optional)

# Convert
Usage: templates convert --source ${TEMPLATE_DIR} --output ${OUTPUT_DIR} --prefix ${PREFIX}

Options:
--source Templates directory
--output Output directory
--prefix Prefix string
"""
    print(help)
}

func invalidArguments() {
    print("Invalid arguments.")
    printHelp()
    exit(1)
}

func main() {
    let args: [String] = CommandLine.arguments
    if args.count < 2 || args.contains("--help") {
        printHelp()
        return
    }
    
    guard let command = Commands(rawValue: args[1]) else {
        print("invalid command: \(args[1])")
        exit(1)
    }
    
    let configure = TemplateConfigure(interactor: TemplateConfigureInteractor())
    
    let arguments = Arguments(arguments: CommandLine.arguments).parse()
    switch command {
    case .set:
        guard let key = arguments["key"],
            let value = arguments["value"] else {
                invalidArguments()
                return
        }
        
        configure.set(value, for: key)
    case .remove:
        guard let key = arguments["key"] else {
                invalidArguments()
                return
        }
        configure.remove(key)
    case .show:
        let json = configure.fetch()
        if let key = arguments["key"], let value = json[key] {
            print(value)
        } else {
            do {
                let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
                guard let string = String(data: data, encoding: .utf8) else {
                    print("json string get failed")
                    return
                }
                print(string)
            } catch {
                print("data get failed with wrror: \(error)")
            }
        }
    case .convert:
        guard let source = arguments["source"],
            let output = arguments["output"],
            let prefix = arguments["prefix"] else {
                invalidArguments()
                return
        }
        
        let json = configure.fetch()
        let templates = TemplatesConverter(source: source, output: output, prefix: prefix, json: json)
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
    
}
main()
