# Smartlook integration into Segment

[Smartlook](https://smartlook.com) records users on websites and in mobile apps. With features that allow you to find useful information even in thousands of recordings in no time.

Smartlook integration to Segment is intentionally very lightweight. As Smartlook records more than just analytics data, it is not possible using just Segment "cloud" intergration, and Smartlook must be, via this integration library, added to your app.

## Instalation

In your `Podfile` add

```ruby
pod 'Segment-Smartlook'
```

## Setup

To simpy run Smartlook, add first your Smartlook app API key to your Smartlook Destination configuration in Segment (link).

Then, amend `SEGAnalytics` configuration:

```swift
import Analytics
import Segment_Smartlook

//...

let config = SEGAnalyticsConfiguration(writeKey: "YOUR_SEGMENT_KEY")

config.use(SLSegmentIntegrationFactory.instance())

SEGAnalytics.setup(with: config)
```
This is sufficient to start Smartlook recording along the Segment.

## Advanced Setup

If tou want or need using the advanced Smartlook setup, you should setup and start Smartlook manually **before** the Segment Analytics setup. Note that to track Segment Analytics event in Smartlook, Smartlook must be still added to the Segment configuration.

```swift
import Analytics
import Segment_Smartlook

//...

Smartlook.setup(key: "YOUR_SMARTLOOK_API_KEY", options: [.renderingMode: .wireframe]);
Smartlook.startRecording()

let config = SEGAnalyticsConfiguration(writeKey: YOUR_SEGMENT_KEY)

config.use(SLSegmentIntegrationFactory.instance())

SEGAnalytics.setup(with: config)
```

## Integrated Tracking

Smartlook follows these Segment Analytics functions. 

Please note that Smartlook supports only string values in properties, and does not support structured properties, thus all values are stringlified to a single string. Also, properties provided by the app are emended by an extra property `sl-origin` that has always value `segment`. 

### Event Tracking

All events tracked by Segment Analytics, and their properties, are router to Smartlook, too. It is valid for both explicite events created by the app, and implicite events that Segment creates for various system events. 

### Screen Tracking

All calls to `screen` method of Segment Analytics are translated as `trackNavigationEvent` in Smartlook.

### Identify

Calls to `identify` method of Segment Analytics are translated to Smartlook's `setUserIdentifier` call, and the traits are transformed to user properties in Smartlook. 

### Alias

Calls to `alias` method of Segment Analytics is routed to Smartlook's `

Importing `Segment-Smartlook` gives you full access to advanced Smartlook capabilities.
