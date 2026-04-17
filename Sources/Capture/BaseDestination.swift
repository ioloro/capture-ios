/// SwiftyBeaver-compatible base destination class.
// Safety invariant: all access to BaseDestination instances is serialized through SwiftyBeaver's
// concurrent queue (barrier writes for registration, sync reads for dispatch). Subclasses must
// not introduce unsynchronized mutable state accessed from multiple threads.
open class BaseDestination: @unchecked Sendable {
    public init() {}

    /// Called when a log message is dispatched. Override in subclasses to handle log events.
    ///
    /// - returns: The formatted log string, or nil.
    @discardableResult
    open func send(
        _ level: SwiftyBeaver.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: Int,
        context: Any? = nil
    ) -> String? {
        return nil
    }
}
