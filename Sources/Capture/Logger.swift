import Foundation

/// The main entry point for the Capture SDK.
public final class Logger: @unchecked Sendable {
    private static let shared = Logger()
    private let lock = NSLock()
    private var _impl: (any Logging)?
    private var _apiKey: String = ""
    private var _sessionStrategy: SessionStrategy = .fixed()

    private init() {}

    private var impl: (any Logging)? {
        self.lock.lock()
        defer { self.lock.unlock() }
        return self._impl
    }

    // MARK: - Lifecycle

    /// Starts the Capture SDK.
    ///
    /// - parameter apiKey:          The API key for the Capture SDK.
    /// - parameter sessionStrategy: The session strategy to use.
    /// - parameter integrations:    Optional integrations to start alongside the SDK.
    public static func start(
        withAPIKey apiKey: String,
        sessionStrategy: SessionStrategy = .fixed(),
        integrations: [Integration] = []
    ) {
        let logger = InternalLogger(apiKey: apiKey, sessionStrategy: sessionStrategy)
        shared.lock.lock()
        shared._impl = logger
        shared._apiKey = apiKey
        shared._sessionStrategy = sessionStrategy
        shared.lock.unlock()

        for integration in integrations {
            integration.start(with: logger, apiKey: apiKey, sessionStrategy: sessionStrategy)
        }
    }

    /// Enables integrations after the SDK has been started.
    ///
    /// Usage:
    /// ```swift
    /// Logger.enableIntegrations([.cocoaLumberjack(), .swiftyBeaver()])
    /// ```
    public static func enableIntegrations(_ integrations: [Integration]) {
        shared.lock.lock()
        let logger = shared._impl
        let apiKey = shared._apiKey
        let sessionStrategy = shared._sessionStrategy
        shared.lock.unlock()

        guard let logger else { return }

        for integration in integrations {
            integration.start(with: logger, apiKey: apiKey, sessionStrategy: sessionStrategy)
        }
    }

    // MARK: - Session

    /// The current session ID, if the SDK has been started.
    public static var sessionID: String? {
        shared.impl?.sessionID
    }

    /// The current session URL, if the SDK has been started.
    public static var sessionURL: String? {
        shared.impl?.sessionURL
    }

    /// The device ID, if the SDK has been started.
    public static var deviceID: String? {
        shared.impl?.deviceID
    }

    /// Starts a new session.
    public static func startNewSession() {
        shared.impl?.startNewSession()
    }

    // MARK: - Logging

    /// Logs a message at the given level.
    public static func log(
        level: LogLevel,
        message: @autoclosure () -> String,
        file: String? = #file,
        line: Int? = #line,
        function: String? = #function,
        fields: Fields? = nil,
        error: Error? = nil
    ) {
        shared.impl?.log(
            level: level,
            message: message(),
            file: file,
            line: line,
            function: function,
            fields: fields,
            error: error
        )
    }

    /// Logs a trace-level message.
    public static func logTrace(
        _ message: @autoclosure () -> String,
        file: String? = #file,
        line: Int? = #line,
        function: String? = #function,
        fields: Fields? = nil
    ) {
        log(level: .trace, message: message(), file: file, line: line, function: function, fields: fields)
    }

    /// Logs a debug-level message.
    public static func logDebug(
        _ message: @autoclosure () -> String,
        file: String? = #file,
        line: Int? = #line,
        function: String? = #function,
        fields: Fields? = nil
    ) {
        log(level: .debug, message: message(), file: file, line: line, function: function, fields: fields)
    }

    /// Logs an info-level message.
    public static func logInfo(
        _ message: @autoclosure () -> String,
        file: String? = #file,
        line: Int? = #line,
        function: String? = #function,
        fields: Fields? = nil
    ) {
        log(level: .info, message: message(), file: file, line: line, function: function, fields: fields)
    }

    /// Logs a warning-level message.
    public static func logWarning(
        _ message: @autoclosure () -> String,
        file: String? = #file,
        line: Int? = #line,
        function: String? = #function,
        fields: Fields? = nil
    ) {
        log(level: .warning, message: message(), file: file, line: line, function: function, fields: fields)
    }

    /// Logs an error-level message.
    public static func logError(
        _ message: @autoclosure () -> String,
        file: String? = #file,
        line: Int? = #line,
        function: String? = #function,
        fields: Fields? = nil,
        error: Error? = nil
    ) {
        log(level: .error, message: message(), file: file, line: line, function: function, fields: fields, error: error)
    }

    // MARK: - Fields

    /// Adds a field to all future log events.
    public static func addField(withKey key: String, value: Encodable & Sendable) {
        shared.impl?.addField(withKey: key, value: value)
    }

    /// Removes a previously added field.
    public static func removeField(withKey key: String) {
        shared.impl?.removeField(withKey: key)
    }

    // MARK: - Device

    /// Creates a temporary device code for linking a device.
    public static func createTemporaryDeviceCode(completion: @escaping (Result<String, Error>) -> Void) {
        shared.impl?.createTemporaryDeviceCode(completion: completion)
    }

    /// Registers an opaque user ID for the current device.
    public static func registerOpaqueUserID(_ userID: String) {
        shared.impl?.registerOpaqueUserID(userID)
    }

    // MARK: - Spans

    /// Starts a new span for tracking a unit of work.
    public static func startSpan(
        name: String,
        level: LogLevel = .info,
        file: String? = #file,
        line: Int? = #line,
        function: String? = #function,
        fields: Fields? = nil,
        startTimeInterval: TimeInterval? = nil,
        parentSpanID: UUID? = nil
    ) -> Span? {
        shared.impl?.startSpan(
            name: name,
            level: level,
            file: file,
            line: line,
            function: function,
            fields: fields,
            startTimeInterval: startTimeInterval,
            parentSpanID: parentSpanID
        )
    }

    // MARK: - Instrumentation

    /// Logs the app launch time-to-interactive duration.
    public static func logAppLaunchTTI(_ duration: TimeInterval) {
        shared.impl?.logAppLaunchTTI(duration)
    }

    /// Logs a screen view event.
    public static func logScreenView(screenName: String) {
        shared.impl?.logScreenView(screenName: screenName)
    }

    /// Sets the SDK sleep mode.
    public static func setSleepMode(_ mode: SleepMode) {
        shared.impl?.setSleepMode(mode)
    }

    /// Registers a feature flag exposure event.
    public static func setFeatureFlagExposure(withName name: String, variant: String) {
        shared.impl?.setFeatureFlagExposure(withName: name, variant: variant)
    }

    /// Registers a feature flag exposure event with a boolean variant.
    public static func setFeatureFlagExposure(withName name: String, variant: Bool) {
        shared.impl?.setFeatureFlagExposure(withName: name, variant: variant)
    }
}

// MARK: - Internal Logger

private final class InternalLogger: Logging {
    let sessionID: String
    let sessionURL: String
    let deviceID: String

    init(apiKey _: String, sessionStrategy: SessionStrategy) {
        self.sessionID = sessionStrategy.makeSession()
        self.sessionURL = "https://app.bitdrift.io/sessions/\(self.sessionID)"
        self.deviceID = UUID().uuidString
    }

    func log(
        level _: LogLevel,
        message _: @autoclosure () -> String,
        file _: String?,
        line _: Int?,
        function _: String?,
        fields _: Fields?,
        error _: Error?
    ) {}

    func startNewSession() {}
    func addField(withKey _: String, value _: Encodable & Sendable) {}
    func removeField(withKey _: String) {}
    func createTemporaryDeviceCode(completion _: @escaping (Result<String, Error>) -> Void) {}

    func startSpan(
        name _: String,
        level _: LogLevel,
        file _: String?,
        line _: Int?,
        function _: String?,
        fields _: Fields?,
        startTimeInterval _: TimeInterval?,
        parentSpanID _: UUID?
    ) -> Span {
        SpanImpl { _ in }
    }

    func logAppLaunchTTI(_: TimeInterval) {}
    func logScreenView(screenName _: String) {}
    func setSleepMode(_: SleepMode) {}
    func setFeatureFlagExposure(withName _: String, variant _: String) {}
    func setFeatureFlagExposure(withName _: String, variant _: Bool) {}
    func registerOpaqueUserID(_: String) {}
}
