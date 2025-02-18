import Cocoa
import ServiceManagement

class StatusBarController {
    private var statusBarItem: NSStatusItem!
    private var menu: NSMenu!
    private var screenManager: ScreenConfigurationManager
    private var savePopover: NSPopover?

    init(screenManager: ScreenConfigurationManager) {
        self.screenManager = screenManager
        setupStatusBarItem()
        setupMenu()
    }

    private func setupStatusBarItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusBarItem.button {
            button.image = NSImage(
                systemSymbolName: "rectangle.on.rectangle",
                accessibilityDescription: "Screen Swapper")
        }
    }

    private func setupMenu() {
        menu = NSMenu()

        // Add configurations directly
        updateConfigurationsMenu(menu)
        menu.addItem(NSMenuItem.separator())

        // Configuration management section
        let saveItem = NSMenuItem(
            title: "Save Current Layout...", action: #selector(saveCurrentLayout),
            keyEquivalent: "s")
        saveItem.target = self
        menu.addItem(saveItem)

        // Remove configurations submenu
        let removeMenu = NSMenu()
        updateRemoveConfigurationsMenu(removeMenu)
        let removeItem = NSMenuItem(title: "Remove Configuration", action: nil, keyEquivalent: "")
        removeItem.submenu = removeMenu
        menu.addItem(removeItem)

        menu.addItem(NSMenuItem.separator())

        // Preferences section
        let startAtLoginItem = NSMenuItem(
            title: "Start at Login",
            action: #selector(toggleStartAtLogin(_:)),
            keyEquivalent: "")
        startAtLoginItem.target = self
        startAtLoginItem.state = isStartAtLoginEnabled() ? .on : .off
        menu.addItem(startAtLoginItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(
            NSMenuItem(
                title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusBarItem.menu = menu
    }

    private func isStartAtLoginEnabled() -> Bool {
        if let bundleId = Bundle.main.bundleIdentifier {
            return SMAppService.mainApp.status == .enabled
        }
        return false
    }

    @objc private func toggleStartAtLogin(_ sender: NSMenuItem) {
        do {
            if isStartAtLoginEnabled() {
                try SMAppService.mainApp.unregister()
                sender.state = .off
            } else {
                try SMAppService.mainApp.register()
                sender.state = .on
            }
        } catch {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText =
                "Could not \(sender.state == .on ? "disable" : "enable") start at login: \(error.localizedDescription)"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()

            // Revert the state
            sender.state = sender.state == .on ? .off : .on
        }
    }

    private func updateConfigurationsMenu(_ menu: NSMenu) {
        menu.removeAllItems()

        let configurations = screenManager.getConfigurations()
        if configurations.isEmpty {
            let emptyItem = NSMenuItem(
                title: "No saved configurations", action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            menu.addItem(emptyItem)
        } else {
            for config in configurations {
                let item = NSMenuItem(
                    title: config.name,
                    action: #selector(loadConfiguration(_:)),
                    keyEquivalent: "")
                item.target = self
                menu.addItem(item)
            }
        }
    }

    private func updateRemoveConfigurationsMenu(_ menu: NSMenu) {
        menu.removeAllItems()

        let configurations = screenManager.getConfigurations()
        if configurations.isEmpty {
            let emptyItem = NSMenuItem(
                title: "No saved configurations", action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            menu.addItem(emptyItem)
        } else {
            for config in configurations {
                let item = NSMenuItem(
                    title: config.name,
                    action: #selector(removeConfiguration(_:)),
                    keyEquivalent: "")
                item.target = self
                menu.addItem(item)
            }
        }
    }

    @objc private func removeConfiguration(_ sender: NSMenuItem) {
        screenManager.removeConfiguration(named: sender.title)
        setupMenu()  // Rebuild entire menu
    }

    @objc private func saveCurrentLayout() {
        let popover = NSPopover()
        popover.behavior = .transient

        let viewController = NSViewController()
        let containerView = NSView(frame: NSRect(x: 0, y: 0, width: 250, height: 80))

        let label = NSTextField(frame: NSRect(x: 10, y: 45, width: 230, height: 25))
        label.stringValue = "Enter configuration name:"
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = .clear
        label.drawsBackground = false

        let input = NSTextField(frame: NSRect(x: 10, y: 15, width: 150, height: 24))
        input.placeholderString = "Configuration name"

        let saveButton = NSButton(frame: NSRect(x: 170, y: 15, width: 70, height: 24))
        saveButton.title = "Save"
        saveButton.bezelStyle = .rounded
        saveButton.action = #selector(saveName(_:))
        saveButton.target = self

        containerView.addSubview(label)
        containerView.addSubview(input)
        containerView.addSubview(saveButton)

        viewController.view = containerView
        popover.contentViewController = viewController

        if let button = statusBarItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            input.becomeFirstResponder()
        }

        self.savePopover = popover
    }

    @objc private func saveName(_ sender: NSButton) {
        guard
            let input = sender.superview?.subviews.first(where: {
                $0 is NSTextField && $0.frame.origin.y == 15
            }) as? NSTextField,
            !input.stringValue.isEmpty
        else {
            return
        }

        screenManager.saveCurrentConfiguration(name: input.stringValue)
        setupMenu()  // Rebuild entire menu
        savePopover?.close()
        savePopover = nil
    }

    @objc private func loadConfiguration(_ sender: NSMenuItem) {
        screenManager.applyConfiguration(named: sender.title)
    }
}
