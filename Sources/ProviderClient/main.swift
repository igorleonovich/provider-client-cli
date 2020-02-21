import Foundation

let core = Core()
core.setup()
core.connect {
    core.fullClientUpdate {
        core.stateController.startStateUpdating()
    }
}

RunLoop.main.run()
