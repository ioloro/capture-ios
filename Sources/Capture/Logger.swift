import Foundation

/// The main entry point for the Capture SDK.
public final class Logger: @unchecked Sendable {
    private static let shared = Logger()
    private let lock = NSLock()
    private var _impl: (any Logging)?

    private init() {}

    private var impl: (any Logging)? {
        self.lock.lock()
        defer { self.lock.unlock() }
        return self._impl
    }

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
        shared.lock.unlock()

        for integration in integrations {
            integration.start(with: logger, apiKey: apiKey, sessionStrategy: sessionStrategy)
        }
    }

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

    /// Starts a new session.
    public static func startNewSession() {
        shared.impl?.startNewSession()
    }

    /// Adds a field to all future log events.
    public static func addField(withKey key: String, value: Encodable & Sendable) {
        shared.impl?.addField(withKey: key, value: value)
    }

    /// Removes a previously added field.
    public static func removeField(withKey key: String) {
        shared.impl?.removeField(withKey: key)
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
