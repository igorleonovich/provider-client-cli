import Foundation

let cliTool = CLITool()
cliTool.run()

let core = Core()
core.setup()
core.connect { error in
    if let error = error {
        print(error)
    } else {
        core.fullClientUpdate {
            core.statsController.startStatsUpdating()
        }
    }
}

RunLoop.main.run()
