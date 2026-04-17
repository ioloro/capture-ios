extension Integration {
    /// A Capture SDK integration that forwards all logs emitted using the SwiftyBeaver-compatible
    /// logging system to Capture SDK.
    ///
    /// - returns: The SwiftyBeaver Capture Logger SDK integration.
    public static func swiftyBeaver() -> Integration {
        return Integration { logger, _, _ in
            SwiftyBeaver.addDestination(
                CaptureSwiftyBeaverLogger(logger: logger)
            )
        }
    }
}

/// The wrapper around Capture SDK logger that subclasses `BaseDestination` and can be used as a
/// drop-in solution for forwarding SwiftyBeaver-style logs to bitdrift Capture SDK.
final class CaptureSwiftyBeaverLogger: BaseDestination, @unchecked Sendable {
    private let logger: Logging

    init(logger: Logging) {
        self.logger = logger
        super.init()
    }

    override func send(
        _ level: SwiftyBeaver.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: Int,
        context: Any? = nil
    ) -> String? {
        let fields = context.flatMap { context in
            return [
                "context": String(describing: context).trimmingCharacters(in: .whitespacesAndNewlines),
                "source": "SwiftyBeaver",
                "thread": thread,
            ]
        }

        self.logger.log(
            level: LogLevel(level),
            message: msg,
            file: file,
            line: line,
            function: function,
            fields: fields,
            error: nil
        )

        return super.send(
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

extension LogLevel {
    /// Initializes a new instance of Capture log level using provided SwiftyBeaver log level.
    ///
    /// - parameter logLevel: SwiftyBeaver log level.
    init(_ logLevel: SwiftyBeaver.Level) {
        switch logLevel {
        case .verbose:
            self = .trace
        case .debug:
            self = .debug
        case .info:
            self = .info
        case .warning:
            self = .warning
        case .error:
            self = .error
        case .critical:
            self = .error
        case .fault:
            self = .error
        }
    }
}
