/// An integration that bridges an external logging framework with the Capture SDK.
public struct Integration: Sendable {
    let starter: @Sendable (Logging, String, SessionStrategy) -> Void

    /// Creates a new integration with a closure invoked when the SDK starts.
    ///
    /// - parameter start: A closure called when the SDK starts with the logger instance,
    ///   API key, and session strategy.
    public init(_ start: @escaping @Sendable (Logging, String, SessionStrategy) -> Void) {
        self.starter = start
    }

    /// Starts this integration with the given logger.
    public func start(with logger: Logging, apiKey: String = "", sessionStrategy: SessionStrategy = .fixed()) {
        self.starter(logger, apiKey, sessionStrategy)
    }
}
