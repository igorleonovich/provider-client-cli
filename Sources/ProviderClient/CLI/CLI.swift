import Foundation

struct CLI {
    
    @discardableResult
    static func runCommand(args : String...) -> (output: [String], error: [String], exitCode: Int32) {

        var output : [String] = []
        var error : [String] = []

        let task = Process()
        let path = "/usr/bin/env"
        if #available(OSX 10.13, *) {
            task.executableURL = URL(fileURLWithPath: path)
        } else {
            task.launchPath = path
        }
        task.arguments = args

        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe

        if #available(OSX 10.13, *) {
            do {
                try task.run()
            } catch {
                print(error)
            }
        } else {
            task.launch()
        }

        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }

        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }

        task.waitUntilExit()
        let status = task.terminationStatus

        return (output, error, status)
    }
}
