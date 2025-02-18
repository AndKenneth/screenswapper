import ApplicationServices
import Cocoa
import CoreGraphics

struct ScreenConfiguration: Codable {
    let name: String
    let displays: [DisplayConfiguration]
}

struct DisplayConfiguration: Codable {
    let displayID: CGDirectDisplayID
    let bounds: CGRect
    let scale: Double
}

class ScreenConfigurationManager {
    private var configurations: [ScreenConfiguration] = []
    private var currentConfigIndex: Int = 0

    init() {
        loadConfigurations()
    }

    func getConfigurations() -> [ScreenConfiguration] {
        return configurations
    }

    func saveCurrentConfiguration(name: String) {
        var displays: [DisplayConfiguration] = []

        var displayCount: UInt32 = 0
        guard CGGetActiveDisplayList(0, nil, &displayCount) == .success else { return }

        let allocatedDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(
            capacity: Int(displayCount))
        defer { allocatedDisplays.deallocate() }

        guard CGGetActiveDisplayList(displayCount, allocatedDisplays, &displayCount) == .success
        else { return }

        for i in 0..<Int(displayCount) {
            let display = allocatedDisplays[i]
            let bounds = CGDisplayBounds(display)
            let scale =
                NSScreen.screens.first(where: {
                    $0.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")]
                        as? CGDirectDisplayID == display
                })?.backingScaleFactor ?? 1.0

            displays.append(
                DisplayConfiguration(
                    displayID: display,
                    bounds: bounds,
                    scale: scale
                ))
        }

        let config = ScreenConfiguration(name: name, displays: displays)
        configurations.append(config)
        saveConfigurations()
    }

    func cycleToNextConfiguration() {
        guard !configurations.isEmpty else { return }

        currentConfigIndex = (currentConfigIndex + 1) % configurations.count
        applyConfiguration(named: configurations[currentConfigIndex].name)
    }

    func applyConfiguration(named configName: String) {
        guard let config = configurations.first(where: { $0.name == configName }) else { return }
        var configRef: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&configRef)

        for display in config.displays {
            guard let configRef = configRef else { continue }

            CGConfigureDisplayOrigin(
                configRef, display.displayID,
                Int32(display.bounds.origin.x),
                Int32(display.bounds.origin.y))
        }

        if let configRef = configRef {
            CGCompleteDisplayConfiguration(configRef, .permanently)
        }
    }

    func removeConfiguration(named configName: String) {
        configurations.removeAll { $0.name == configName }
        saveConfigurations()
    }

    private func loadConfigurations() {
        guard let data = UserDefaults.standard.data(forKey: "ScreenConfigurations"),
            let configs = try? JSONDecoder().decode([ScreenConfiguration].self, from: data)
        else {
            return
        }
        configurations = configs
    }

    private func saveConfigurations() {
        guard let data = try? JSONEncoder().encode(configurations) else { return }
        UserDefaults.standard.set(data, forKey: "ScreenConfigurations")
    }
}
