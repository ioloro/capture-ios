/// Logs a verbose-level message via the CocoaLumberjack-compatible system.
public func DDLogVerbose(
    _ message: @autoclosure () -> String,
    file: String = #file,
    function: String = #function,
    line: UInt = #line
) {
    DDLog.log(level: .verbose, flag: .verbose, message: message(), file: file, function: function, line: line)
}

/// Logs a debug-level message via the CocoaLumberjack-compatible system.
public func DDLogDebug(
    _ message: @autoclosure () -> String,
    file: String = #file,
    function: String = #function,
    line: UInt = #line
) {
    DDLog.log(level: .debug, flag: .debug, message: message(), file: file, function: function, line: line)
}

/// Logs an info-level message via the CocoaLumberjack-compatible system.
public func DDLogInfo(
    _ message: @autoclosure () -> String,
    file: String = #file,
    function: String = #function,
    line: UInt = #line
) {
    DDLog.log(level: .info, flag: .info, message: message(), file: file, function: function, line: line)
}

/// Logs a warning-level message via the CocoaLumberjack-compatible system.
public func DDLogWarn(
    _ message: @autoclosure () -> String,
    file: String = #file,
    function: String = #function,
    line: UInt = #line
) {
    DDLog.log(level: .warning, flag: .warning, message: message(), file: file, function: function, line: line)
}

/// Logs an error-level message via the CocoaLumberjack-compatible system.
public func DDLogError(
    _ message: @autoclosure () -> String,
    file: String = #file,
    function: String = #function,
    line: UInt = #line
) {
    DDLog.log(level: .error, flag: .error, message: message(), file: file, function: function, line: line)
}
