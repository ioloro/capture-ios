import Foundation

/// CocoaLumberjack-compatible log dispatcher.
public final class DDLog: @unchecked Sendable {
    private static let instance = DDLog()
    private let queue = DispatchQueue(label: "io.bitdrift.capture.DDLog", attributes: .concurrent)
    private var _loggers: [DDLogger] = []

    private var loggers: [DDLogger] {
        self.queue.sync { self._loggers }
    }

    /// Adds a logger to the DDLog system.
    public static func add(_ logger: DDLogger) {
        instance.queue.async(flags: .barrier) {
            instance._loggers.append(logger)
        }
    }

    /// Dispatches a log message to all registered loggers.
    static func log(
        asynchronous: Bool = true,
        level: DDLogLevel,
        flag: DDLogFlag,
        message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        let msg = DDLogMessage(
            message: message(),
            level: level,
            flag: flag,
            file: file,
            function: function,
            line: line
        )

        let loggers = instance.loggers
        if asynchronous {
            DispatchQueue.global().async {
                for logger in loggers {
                    logger.log(message: msg)
                }
            }
        } else {
            for logger in loggers {
                logger.log(message: msg)
            }
        }
    }
}
