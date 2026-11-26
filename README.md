# GeniusSDKFramework

Genius attribution SDK for iOS, Mac Catalyst, tvOS and macOS. It ships as a prebuilt XCFramework through CocoaPods.

## Requirements

| Platform | Minimum version |
| --- | --- |
| iOS | 13.0 |
| Mac Catalyst | 13.1 |
| tvOS | 14.0 |
| macOS | 12.0 |

- Xcode 16 or later.
- Sandboxed macOS apps need the `com.apple.security.network.client` entitlement.

## Installation

Add the pod to your `Podfile` and run `pod install`:

```ruby
pod 'GeniusSDKFramework', '~> 1.2'
```

## Usage

```swift
import GeniusSDKFramework

let genius = GeniusSDK() // every instance shares one engine per process

// Optional, before connect():
genius.setRequestsTrackingAuthorization(true)
genius.setReadsPasteboard(true)

Task {
    await genius.connect() // records the install or open and starts sending events
    let launch = genius.dataString // the launch payload as JSON
    let attribution = await genius.awaitDeferredData()
}

Task {
    await genius.logEvent(
        eventName: .deposit,
        eventValue: [GeniusSDK.EventParam.revenue: 9.99, GeniusSDK.EventParam.currency: "USD"]
    )
}
```

Built-in event names are `.install`, `.open`, `.firstDeposit`, `.deposit`, `.login` and `.signup`; `connect()` sends `install` and `open` itself. Use `.custom("name")` for anything else.

### How it behaves

- `connect()` is idempotent per process: concurrent and repeated calls share one launch.
- `logEvent` captures the event before it suspends, so calls made in order from one actor (such as the main actor) are stored and sent in that order. It returns once the event is stored. Code that can't `await` can call `logEvent(eventName:eventValue:completion:)` instead.
- Events logged before `connect()` are sent after the launch event. If the app was launched in the background, they are sent right away and the launch event follows when the app first comes to the foreground.
- `isFirstOpen` tells whether this launch is the install. It is valid before `connect()` finishes.
- `stop(true)` clears pending events and drops new ones until `stop(false)`. The setting is persisted.
- `setCustomerUserId(_:)` and `setPushToken(_:)` are persisted. Pass `nil` to clear them.
- `buildDynamicLink(url:params:)` adds the parameters to the link's query, form-encoded and sorted by key. `getDeepLinkParams(url:)` parses a deep link's query into `deepLinkParams` on the same `GeniusSDK` instance.

## Defaults

| Setting | Default |
| --- | --- |
| `setRequestsTrackingAuthorization(_:)` | Off |
| `setReadsPasteboard(_:)` | Off |
| `setMinTimeBetweenSessions(_:)` | 5 seconds. A `session` event is sent when the app comes back to the foreground after at least this long in the background (not on macOS); `0` turns it off. |
| `GeniusSDK.setDebugLogging(_:)` | Off; when on, payloads are logged to `os_log` (subsystem `com.eshkol.genius`) |

## Tracking authorization, pasteboard and Apple Search Ads

- **App Tracking Transparency:** with `setRequestsTrackingAuthorization(true)`, `connect()` shows the ATT prompt once the app is active, if the user hasn't answered it yet. The prompt is shown only if your app's Info.plist contains `NSUserTrackingUsageDescription`, and never in app extensions. The IDFA is sent only after the user allows tracking. Apps that show the prompt themselves can call `requestATT(completion:)`.
- **Pasteboard** (iOS and Mac Catalyst): with `setReadsPasteboard(true)`, the first launch after install reads the attribution data copied by the Genius landing page; anything else on the pasteboard is ignored. On iOS 16 and later, reading text copied from another app shows the system "Allow Paste" alert.
- **Apple Search Ads** (iOS and Mac Catalyst 14.3+, and macOS): the first launch after install reads the AdServices attribution token, which is then sent with every event. AdServices is weak-linked, so the framework still loads on iOS 13.

## Event delivery

Events are queued on disk and sent in order, at least once. A send that fails because the device is offline, or because the server returns a temporary error, is retried with exponential backoff, at most 5 minutes apart, so events survive offline periods and app restarts. When more than 200 events are waiting, the oldest is dropped, but never a pending install.

Upgrading from 1.0.x needs no migration code: the first launch imports the IDs stored by the older version.

## Privacy manifest

Every slice of the framework bundles a `PrivacyInfo.xcprivacy`:

- `NSPrivacyTracking` is false and no tracking domains are declared.
- Collected data types, all linked to the user and none used for tracking:
  - Device ID and advertising data: analytics, developer advertising
  - Product interaction and coarse location: analytics
  - User ID (the customer user ID): analytics, app functionality
- Required-reason APIs: UserDefaults (`CA92.1`) and file timestamps (`C617.1`).

## License

GeniusSDKFramework is available under the MIT license. See [LICENSE](LICENSE).
