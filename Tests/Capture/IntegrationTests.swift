import Capture
import CaptureMocks
import XCTest

final class IntegrationTests: XCTestCase {
    func testCapture() {
        Capture.Logger.start(withAPIKey: "foo", sessionStrategy: .fixed())
        XCTAssertNotNil(Capture.Logger.sessionID)
    }

    func testCaptureWithActivityBasedSession() {
        Capture.Logger.start(withAPIKey: "foo", sessionStrategy: .activityBased())
        XCTAssertNotNil(Capture.Logger.sessionID)
        XCTAssertNotNil(Capture.Logger.sessionURL)
        XCTAssertNotNil(Capture.Logger.deviceID)
    }

    func testConvenienceLoggingMethods() {
        Capture.Logger.start(withAPIKey: "foo", sessionStrategy: .fixed())
        // Verify these compile and don't crash — the internal logger is a no-op.
        Capture.Logger.logTrace("trace message")
        Capture.Logger.logDebug("debug message")
        Capture.Logger.logInfo("info message", fields: ["key": "value"])
        Capture.Logger.logWarning("warning message")
        Capture.Logger.logError("error message")
    }

    func testEnableIntegrations() {
        Capture.Logger.start(withAPIKey: "foo", sessionStrategy: .fixed())

        // enableIntegrations should not crash when called after start.
        Capture.Logger.enableIntegrations([.cocoaLumberjack(), .swiftyBeaver()])
    }

    // MARK: - CocoaLumberjack Integration

    func testAddingCaptureDDLogger() {
        let expectation = self.expectation(description: "all logs are forwarded to Capture logger")
        expectation.expectedFulfillmentCount = 5

        let logger = MockLogging()
        logger.logExpectation = expectation

        Integration.cocoaLumberjack().start(with: logger)

        DDLogVerbose("Verbose")
        DDLogDebug("Debug")
        DDLogInfo("Info")
        DDLogWarn("Warn")
        DDLogError("Error")

        XCTAssertEqual(.completed, XCTWaiter().wait(for: [expectation], timeout: 5))
        XCTAssertEqual(logger.logs.map(\.message), [
            "Verbose",
            "Debug",
            "Info",
            "Warn",
            "Error",
        ])
    }

    // MARK: - SwiftyBeaver Integration

    func testAddingCaptureSwiftyBeaverLogger() {
        let expectation = self.expectation(description: "all logs are forwarded to Capture logger")
        expectation.expectedFulfillmentCount = 5

        let logger = MockLogging()
        logger.logExpectation = expectation

        Integration.swiftyBeaver().start(with: logger)

        SwiftyBeaver.verbose("Verbose")
        SwiftyBeaver.debug("Debug")
        SwiftyBeaver.info("Info")
        SwiftyBeaver.warning("Warning")
        SwiftyBeaver.error("Error")

        XCTAssertEqual(.completed, XCTWaiter().wait(for: [expectation], timeout: 5))
        XCTAssertEqual(logger.logs.map(\.message), [
            "Verbose",
            "Debug",
            "Info",
            "Warning",
            "Error",
        ])
    }
}
