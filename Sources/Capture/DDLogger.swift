/// CocoaLumberjack-compatible logger protocol.
public protocol DDLogger: AnyObject, Sendable {
    func log(message: DDLogMessage)
    var logFormatter: DDLogFormatter? { get set }
}

/// CocoaLumberjack-compatible log formatter protocol.
public protocol DDLogFormatter {
    func format(message: DDLogMessage) -> String?
}
