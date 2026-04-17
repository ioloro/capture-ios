/// CocoaLumberjack-compatible log level.
public enum DDLogLevel: UInt, Sendable {
    case off
    case error
    case warning
    case info
    case debug
    case verbose
    case all
}

/// CocoaLumberjack-compatible log flag.
public struct DDLogFlag: OptionSet, Sendable {
    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let error   = DDLogFlag(rawValue: 1 << 0)
    public static let warning = DDLogFlag(rawValue: 1 << 1)
    public static let info    = DDLogFlag(rawValue: 1 << 2)
    public static let debug   = DDLogFlag(rawValue: 1 << 3)
    public static let verbose = DDLogFlag(rawValue: 1 << 4)
}
