import Vapor
import DeviceCheckinWatcher

struct DeviceWatcher: LifecycleHandler {

    func didBoot(_ application: Application) throws {
        application.startTheWatcher()
    }
}

extension Application {

    func startTheWatcher() {
        DMesgWatcher.runner.run()
    }
}