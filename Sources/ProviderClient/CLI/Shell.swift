import Foundation

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
//    task.launchPath = "~/"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}
