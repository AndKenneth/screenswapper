import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?
    private var screenManager: ScreenConfigurationManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        screenManager = ScreenConfigurationManager()
        if let screenManager = screenManager {
            statusBarController = StatusBarController(screenManager: screenManager)
        }
    }

    @objc func saveCurrentLayout(_ sender: Any?) {
        let alert = NSAlert()
        alert.messageText = "Save Configuration"
        alert.informativeText = "Enter a name for this screen configuration:"

        let input = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        alert.accessoryView = input
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Cancel")

        if alert.runModal() == .alertFirstButtonReturn {
            screenManager?.saveCurrentConfiguration(name: input.stringValue)
        }
    }

    @objc func showConfigurations(_ sender: Any?) {
        // TODO: Implement configuration management window
    }
}
