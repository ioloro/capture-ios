import Foundation

extension Integration {
    /// A Capture SDK integration that forwards all logs emitted using the CocoaLumberjack-compatible
    /// logging system to Capture SDK.
    ///
    /// - returns: The CocoaLumberjack Capture Logger SDK integration.
    public static func cocoaLumberjack() -> Integration {
        return Integration { logger, _, _ in
            DDLog.add(CaptureDDLogger(logger: logger))
        }
    }
}

/// The wrapper around Capture SDK logger that conforms to `DDLogger` protocol and can be used as a
/// drop-in solution for forwarding CocoaLumberjack-style logs to bitdrift Capture SDK.
// Safety invariant: all access to CaptureDDLogger instances is serialized through DDLog's
// concurrent queue (barrier writes, sync reads). The mutable `logFormatter` property is
// therefore never subject to data races.
final class CaptureDDLogger: NSObject, DDLogger, @unchecked Sendable {
    private let logger: Logging

    var logFormatter: DDLogFormatter?

    init(logger: Logging) {
        self.logger = logger
        super.init()
    }

    func log(message logMessage: DDLogMessage) {
        guard let level = LogLevel(logMessage.level) else {
            return
        }

        self.logger.log(
            level: level,
            message: logMessage.message,
            file: logMessage.file,
            line: Int(logMessage.line),
            function: logMessage.function,
            fields: [
                "source": "CocoaLumberjack",
                "thread": logMessage.threadID,
            ],
            error: nil
        )
    }
}

extension LogLevel {
    /// Initializes a new instance of Capture log level using provided CocoaLumberjack log level.
    ///
    /// - parameter logLevel: CocoaLumberjack log level.
    public init?(_ logLevel: DDLogLevel) {
        switch logLevel {
        case .off:
            return nil
        case .error:
            self = .error
        case .warning:
            self = .warning
        case .info:
            self = .info
        case .debug:
            self = .debug
        case .verbose, .all:
            self = .trace
        }
    }
}
