import Foundation

/// CocoaLumberjack-compatible log message.
public class DDLogMessage: NSObject, @unchecked Sendable {
    public let message: String
    public let level: DDLogLevel
    public let flag: DDLogFlag
    public let file: String
    public let function: String?
    public let line: UInt
    public let threadID: String

    public init(
        message: String,
        level: DDLogLevel,
        flag: DDLogFlag,
        file: String,
        function: String?,
        line: UInt
    ) {
        self.message = message
        self.level = level
        self.flag = flag
        self.file = file
        self.function = function
        self.line = line
        self.threadID = Thread.current.description
        super.init()
    }
}
