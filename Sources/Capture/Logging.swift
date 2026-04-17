import Foundation

/// The core logging interface for the Capture SDK.
public protocol Logging: AnyObject, Sendable {
    func log(
        level: LogLevel,
        message: @autoclosure () -> String,
        file: String?,
        line: Int?,
        function: String?,
        fields: Fields?,
        error: Error?
    )

    var sessionID: String { get }
    var sessionURL: String { get }
    var deviceID: String { get }

    func startNewSession()

    func addField(withKey key: String, value: Encodable & Sendable)
    func removeField(withKey key: String)

    func createTemporaryDeviceCode(completion: @escaping (Result<String, Error>) -> Void)

    func startSpan(
        name: String,
        level: LogLevel,
        file: String?,
        line: Int?,
        function: String?,
        fields: Fields?,
        startTimeInterval: TimeInterval?,
        parentSpanID: UUID?
    ) -> Span

    func logAppLaunchTTI(_ duration: TimeInterval)
    func logScreenView(screenName: String)
    func setSleepMode(_ mode: SleepMode)
    func setFeatureFlagExposure(withName name: String, variant: String)
    func setFeatureFlagExposure(withName name: String, variant: Bool)
    func registerOpaqueUserID(_ userID: String)
}
