import Foundation

let core = Core()
core.setup()
core.connect {
    core.updateClient {
        core.stateController.startStateBroadcasting()
    }
}

RunLoop.main.run()
