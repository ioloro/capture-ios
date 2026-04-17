import Foundation

/// A unit of work that can be tracked over time.
public protocol Span: Sendable {
    var id: UUID { get }
    func end()
    func end(result: SpanResult)
}

/// The result of a span.
public enum SpanResult: Sendable {
    case success
    case failure
}

final class SpanImpl: Span {
    let id: UUID
    private let endHandler: @Sendable (SpanResult) -> Void

    init(id: UUID = UUID(), endHandler: @escaping @Sendable (SpanResult) -> Void) {
        self.id = id
        self.endHandler = endHandler
    }

    func end() {
        self.end(result: .success)
    }

    func end(result: SpanResult) {
        self.endHandler(result)
    }
}
