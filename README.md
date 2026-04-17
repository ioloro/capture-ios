# Capture iOS SDK

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)](https://github.com/bitdriftlabs/capture-ios)
[![Swift](https://img.shields.io/badge/swift-6.0-orange)](https://github.com/bitdriftlabs/capture-ios)
[![License](https://img.shields.io/badge/license-PolyForm%20Shield-green)](LICENSE.txt)

> [!TIP]
> Want to chat with the bitdrift team? Join us on [Slack](https://communityinviter.com/apps/bitdriftpublic/bitdrifters).

The Capture iOS SDK gives you real-time visibility into your app's behavior in production. It captures logs, session data, and performance signals with minimal overhead, then streams them to the [bitdrift](https://bitdrift.io) platform where you can search, alert, and debug in real time.

Get started with our [integration guide](https://docs.bitdrift.io/sdk/quickstart#ios), or read on for a quick overview.

Table of contents
=================

   * [Features](#features)
   * [Requirements](#requirements)
   * [Installation](#installation)
   * [Getting Started](#getting-started)
   * [Integrations](#integrations)
   * [Local Development](#local-development)
   * [Contributing](#contributing)
   * [License](#license)

## Features

**Structured Logging**: Log messages at five severity levels — trace, debug, info, warning, and error — with optional key-value fields attached to every event. Convenience methods like `Logger.logInfo(_:fields:)` make it simple to instrument your code.

**Session Management**: Choose between a fixed session that persists for the app's lifetime, or an activity-based session that automatically rotates after a period of inactivity. Access the current `sessionID` and `sessionURL` to link sessions to your own tools and error reporters.

**Spans**: Track units of work over time with `Logger.startSpan(name:)`. Spans support success/failure results and can be nested via parent span IDs.

**CocoaLumberjack Compatibility**: The SDK includes a full set of CocoaLumberjack-compatible types (`DDLog`, `DDLogVerbose`, `DDLogInfo`, etc.) built in. Enable the integration and your existing `DDLog` calls are automatically forwarded to Capture — no separate library required.

**SwiftyBeaver Compatibility**: Similarly, `SwiftyBeaver`-compatible types (`SwiftyBeaver`, `BaseDestination`) are included. Enable the integration and existing SwiftyBeaver logging is forwarded to Capture.

**Screen Views & Instrumentation**: Record screen transitions with `logScreenView`, measure app launch time-to-interactive, and control SDK behavior with sleep mode.

**Feature Flags**: Report feature flag exposures to correlate experiment variants with runtime behavior.

**Zero External Dependencies**: The entire SDK ships as pure Swift source — no binary frameworks, no third-party packages. One target, one module, zero fetches.

## Requirements

The Capture iOS SDK requires **iOS 15** or later and **Swift 6.0** or later.

## Installation

### Swift Package Manager

Add the package to your `Package.swift`:

```swift
.package(url: "https://github.com/bitdriftlabs/capture-ios.git", from: "<version>")
```

Then add `"Capture"` to the dependencies of your target.

## Getting Started

Initialize the SDK early in your app's lifecycle — ideally in `application(_:didFinishLaunchingWithOptions:)`:

```swift
import Capture

Logger.start(
  withAPIKey: "<your-api-key>",
  sessionStrategy: .activityBased()
)
```

Then log from anywhere:

```swift
Logger.logInfo("User signed in", fields: ["user_id": "abc123"])
```

For the full setup guide including session strategies, fields, spans, and more, see the [official documentation](https://docs.bitdrift.io/sdk/quickstart#ios).

## Integrations

The SDK ships with built-in support for forwarding logs from popular logging frameworks. Enable them at startup or any time after:

```swift
// At startup
Logger.start(
  withAPIKey: "<your-api-key>",
  sessionStrategy: .activityBased(),
  integrations: [.cocoaLumberjack(), .swiftyBeaver()]
)

// Or later
Logger.enableIntegrations([.cocoaLumberjack()])
```

Once enabled, your existing `DDLogInfo(...)` or `SwiftyBeaver.info(...)` calls are forwarded to Capture automatically.

For session linking with error reporters (Bugsnag, Crashlytics, Sentry, Instabug), see [Integrations](https://docs.bitdrift.io/sdk/integrations).

## Local Development

Open `Package.swift` in Xcode to start developing.

```bash
make test      # Run tests
make format    # Run formatters and linter
```

### Building from source

```bash
swift build
swift test
```

## Contributing

We welcome contributions including bug fixes, new features, and documentation improvements. For major changes, please open an issue first to discuss the approach.

## License

The Capture iOS SDK is licensed under the [PolyForm Shield License 1.0.0](LICENSE.txt).
