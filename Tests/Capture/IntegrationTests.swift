import Capture
import CaptureMocks
import XCTest

final class IntegrationTests: XCTestCase {
    func testCapture() {
        Capture.Logger.start(withAPIKey: "foo", sessionStrategy: .fixed())
        XCTAssertNotNil(Capture.Logger.sessionID)
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
