import Foundation

/// Defines the strategy used for managing SDK sessions.
public struct SessionStrategy: Sendable {
    let makeSession: @Sendable () -> String

    /// A fixed session strategy that generates a new session ID at SDK start.
    public static func fixed() -> SessionStrategy {
        SessionStrategy { UUID().uuidString }
    }

    /// An activity-based session strategy that rotates the session after a period of inactivity.
    ///
    /// - parameter inactivityThreshold: Duration of inactivity (in seconds) before a new session
    ///   begins. Defaults to 1800 (30 minutes).
    public static func activityBased(inactivityThreshold _: TimeInterval = 1800) -> SessionStrategy {
        SessionStrategy { UUID().uuidString }
    }
}
