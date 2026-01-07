import AppKit
import ApplicationServices

struct WindowConfiguration {
    let width: CGFloat?
    let height: CGFloat?

    static let defaultWidthRatio: CGFloat = 0.95
    static let defaultHeightRatio: CGFloat = 0.95
}

class ArgumentParser {
    func parse() -> WindowConfiguration {
        var width: CGFloat?
        var height: CGFloat?
        let args = CommandLine.arguments

        for (index, arg) in args.enumerated() {
            switch arg {
            case "-w":
                if index + 1 < args.count, let w = Double(args[index + 1]) {
                    width = CGFloat(w)
                }
            case "-h":
                if index + 1 < args.count, let h = Double(args[index + 1]) {
                    height = CGFloat(h)
                }
            default:
                break
            }
        }

        return WindowConfiguration(width: width, height: height)
    }
}

class ShellCommandExecutor {
    @discardableResult
    func execute(_ command: String) -> Int32 {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", command]

        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus
        } catch {
            print("Failed to run shell command:", error)
            return -1
        }
    }
}

class Window {
    let element: AXUIElement

    init(element: AXUIElement) {
        self.element = element
    }

    var frame: CGRect? {
        var frame = CGRect.zero
        var value: CFTypeRef?

        guard AXUIElementCopyAttributeValue(element, kAXPositionAttribute as CFString, &value) == .success,
              AXValueGetValue(value as! AXValue, .cgPoint, &frame.origin),
              AXUIElementCopyAttributeValue(element, kAXSizeAttribute as CFString, &value) == .success,
              AXValueGetValue(value as! AXValue, .cgSize, &frame.size) else {
            return nil
        }

        return frame
    }

    func setFrame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        var position = CGPoint(x: x, y: y)
        var size = CGSize(width: width, height: height)

        if let pos = AXValueCreate(.cgPoint, &position),
           let sizeValue = AXValueCreate(.cgSize, &size) {
            AXUIElementSetAttributeValue(element, kAXPositionAttribute as CFString, pos)
            AXUIElementSetAttributeValue(element, kAXSizeAttribute as CFString, sizeValue)
        }
    }

    func getMonitor() -> NSScreen? {
        guard let frame = self.frame else { return nil }
        return NSScreen.screens.first { $0.frame.intersects(frame) }
    }
}

class WindowManager {
    func getFrontmostWindow() -> Window? {
        guard let pid = NSWorkspace.shared.frontmostApplication?.processIdentifier else {
            return nil
        }

        let app = AXUIElementCreateApplication(pid)
        var window: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            app,
            kAXFocusedWindowAttribute as CFString,
            &window
        )

        guard result == .success, let window = window else {
            return nil
        }

        return Window(element: window as! AXUIElement)
    }
}

class WindowPositioner {
    func centerWindow(
        _ window: Window,
        on screen: NSScreen,
        configuration: WindowConfiguration
    ) {
        let frame = screen.visibleFrame

        let width = configuration.width ?? frame.width * WindowConfiguration.defaultWidthRatio
        let height = configuration.height ?? frame.height * WindowConfiguration.defaultHeightRatio

        let x = round(frame.origin.x + (frame.width - width) / 2)
        let y = round(frame.origin.y + (frame.height - height) / 2)

        window.setFrame(x: x, y: y, width: width, height: height)
    }
}

class WindowCenteringApp {
    private let argumentParser = ArgumentParser()
    private let shellExecutor = ShellCommandExecutor()
    private let windowManager = WindowManager()
    private let windowPositioner = WindowPositioner()

    func run() {
        let configuration = argumentParser.parse()

        shellExecutor.execute("aerospace layout floating || aerospace layout tiling")

        guard let window = windowManager.getFrontmostWindow() else {
            print("Failed to get frontmost window")
            exit(1)
        }

        guard let screen = window.getMonitor() ?? NSScreen.main else {
            print("Failed to get screen")
            exit(1)
        }

        windowPositioner.centerWindow(window, on: screen, configuration: configuration)
    }
}

let app = WindowCenteringApp()
app.run()
