import Foundation

/// SwiftyBeaver-compatible logging class.
public class SwiftyBeaver: @unchecked Sendable {
    /// SwiftyBeaver-compatible log level.
    public enum Level: Int, Sendable {
        case verbose
        case debug
        case info
        case warning
        case error
        case critical
        case fault
    }

    private static let instance = SwiftyBeaver()
    private let queue = DispatchQueue(label: "io.bitdrift.capture.SwiftyBeaver", attributes: .concurrent)
    private var _destinations: [BaseDestination] = []

    private var destinations: [BaseDestination] {
        self.queue.sync { self._destinations }
    }

    /// Adds a logging destination.
    @discardableResult
    public static func addDestination(_ destination: BaseDestination) -> Bool {
        instance.queue.async(flags: .barrier) {
            instance._destinations.append(destination)
        }
        return true
    }

    /// Logs a verbose-level message.
    public static func verbose(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        dispatch(level: .verbose, message: message(), file: file, function: function, line: line, context: context)
    }

    /// Logs a debug-level message.
    public static func debug(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        dispatch(level: .debug, message: message(), file: file, function: function, line: line, context: context)
    }

    /// Logs an info-level message.
    public static func info(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        dispatch(level: .info, message: message(), file: file, function: function, line: line, context: context)
    }

    /// Logs a warning-level message.
    public static func warning(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        dispatch(level: .warning, message: message(), file: file, function: function, line: line, context: context)
    }

    /// Logs an error-level message.
    public static func error(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        dispatch(level: .error, message: message(), file: file, function: function, line: line, context: context)
    }

    private static func dispatch(
        level: Level,
        message: @autoclosure () -> Any,
        file: String,
        function: String,
        line: Int,
        context: Any?
    ) {
        let msg = "\(message())"
        let thread = Thread.current.description

        for destination in instance.destinations {
            _ = destination.send(
                level,
                msg: msg,
                thread: thread,
                file: file,
                function: function,
                line: line,
                context: context
            )
        }
    }
}
