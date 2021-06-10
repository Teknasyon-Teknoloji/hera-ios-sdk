
# Hera

  

Hera strives to simplify the process of integrating and remotely configuring 3rd party ads libraries in your project, here a list of the features it provides:

  

## Features

  

- ✅ Remotely changing the ad unit id associated with a specific action.

- 🚀 Changing the ads provider on the fly.

- ⏰ Control the ads showing intervals remotly.

- ⚙️ Showing ads based on a specific action.

  

The following document offers a quick guide on how to use this SDK.

  

## Ad Networks

  

Hera supports Google Admob and Facebook Ads out of the box if you would like to integrate other ad networks please refer to their [integration guide](https://github.com/Teknasyon-Teknoloji/hera-ios-sdk/blob/master/NETWORKS.md).

  

## Installation

  

Hera is available through [CocoaPods](http://cocoapods.org/) only. To install it, simply add the following line to your Podfile:

```ruby

pod 'HeraSDK'

```

  

## Usage

### Initialization

First thing first, initialization. To initialize Hera you need to collect advertise attributions first. The advertise attribution is a simple dictionary of type `[String: Codable]`

  

here is an example of how it look like

```swift

["adjust": "{\"trackerToken\":\"xxx\",\"adid\":\"xxxxx\",\"trackerName\":\"Organic\",\"network\":\"Organic\"}"]

```

  

#### HeraUserProperties

After preparing `AddvertisementAttributions` we can initialize `HeraUserProperties` like follows

``` swift

let atrributions = ["adjust": "{\"trackerToken\":\"xxx\",\"adid\":\"xxxxx\",\"trackerName\":\"Organic\",\"network\":\"Organic\"}"]

  

let userProperties = HeraUserProperties(

deviceID: "ABCDEG",

country: "tr",

language: "en-en",

advertiseAttributions: atrributions,

extraData: [:] // any extra data to be passed along in JSON format.

)

```

  

#### API Key and Environment

Get the app-specific api key . Hera supports both `sandbox` and `production` environments depending on whether you build your app for testing or production you must set the it accodingly.

  

Then we can initialize the SDK by calling:

```swift

var apiKey: String

var environment: HeraEnvironment

#if DEBUG

apiKey = "YOUR_STAGE_KEY"

environment = .sandbox

#else

apiKey = "YOUR_PROD_KEY"

environment = .production

#endif

Hera.shared.initialize(apiKey: apiKey, userProperties: userProperties, environment: environment)

```

  

### Preparing Info.plist

  

1.  **Whitelist Admost hosts to do so add the following to your Info.plist**

```xml

<key>NSAppTransportSecurity</key>

<dict>

<key>NSExceptionDomains</key>

<dict>

<key>admost.com</key>

<dict>

<key>NSExceptionAllowsInsecureHTTPLoads</key>

<true/>

<key>NSIncludesSubdomains</key>

<true/>

</dict>

</dict>

</dict>

```

  

**2. (Optional)** By the same token some ads content might need to access user's calender so you may need calendar access permission

  

```xml

<key>NSCalendarsUsageDescription</key>

<string>Some ad content may access calendar</string>

```

  

**3.**  **You must add your AdMob App ID, and Facebook App ID to your plist file with as shown below**. **Otherwise the app will crash.**

  

```xml

<key>GADApplicationIdentifier</key>

<string>YOUR_ADMOB_APP_KEY_HERE</string>

  

key>FacebookAppID</key>

<string>YOUR_FACEBOOK_APP_ID_HERE</string>

```

  

#### 4. Ad Networks Identifiers

  

The following Ids are for Admob, Facebook Ads, Admost ads

  

```xml

<key>SKAdNetworkItems</key>

<array>

<dict>

<key>SKAdNetworkIdentifier</key>

<string>cstr6suwn9.skadnetwork</string>

</dict>

<dict>

<key>SKAdNetworkIdentifier</key>

<string>v9wttpbfk9.skadnetwork</string>

</dict>

<dict>

<key>SKAdNetworkIdentifier</key>

<string>n38lu8286q.skadnetwork</string>

</dict>

</array>

```

  

**5. Ads Tracking Permission(iOS +14.5 only**)

  

_**iOS 14 Only**_: Starting with iOS 14, apps will be required to ask users for permission to access IDFA. In order to ask for this permission and display the App tracking Transparency authorization request for accessing the IDFA, you will need to add NSUserTrackingUsageDescription key to Info.plist file. Learn more about ATT [here](https://developer.apple.com/documentation/apptrackingtransparency).

```xml

key>NSUserTrackingUsageDescription</key>

<string>A message to encourage user to give permission to access IDFA</string>

```

Then ask for the permissions using:

  

```swift

import  AppTrackingTransparency

import  AdSupport

...

if  #available(iOS  14.5, *) {

ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in

})

}

```

Hera follows the ATT framework, and uses ATT to retrieve the user’s authorization status.

  

[CCPA Compliance](https://en.wikipedia.org/wiki/California_Consumer_Privacy_Act  "https://en.wikipedia.org/wiki/California_Consumer_Privacy_Act")

if the user subjects to CCPA rules i.e resides inside California you need to set it using:

```swift

Hera.shared.setSubjectToCCPA(_:)

```

It is defaulted to false

  

### Make your view controller as A delegate

To listen for various Hera events, first import Hera then register for notifications by conforming to `HeraDelegate` and calling:

```swift

Hera.shared.observeEvents(on: self)

```

  

> Please start observing in viewWillAppear method not viewDidLoad to make sure you always listen for event in the current visible view controller.

  

To remove the observer, you can use removeObserver method.

```swift
Hera.shared.removeObserver(from: self)
```

  

### Loading Ads

  
To load ads call loadAd(ofType:action:). Please note that this method is async and it will trigger various events according to the load result. To see all the available events check Events section.

  

```swift
// For interstitial ads
Hera.shared.loadAd(ofType: .interstitial, for: .settings)
// For banner ads
Hera.shared.loadAd(ofType: .banner, for: .inAppSwipe)
```

  

### Showing Ads

  

After loading the ad you can show it by using the following method provided with the ad type and its corresponding action and the right type of ads presenter:

  

##### 1. Banner

- Define your ad container of type UIView

- Give it width and height and centerX constraints. (The standard size of a banner is 320 x 50)

- Add to your super view(if you use layout in code)

- Then call show method like follows: `Hera.shared.showAd(ofType: .banner, for: adAction, on: bannerContainerView)`

  
  

> Please make sure that your banner container view has both frame and
> bound and is visible before sending it to Hera. i.e the frame size is
> not zero.

<br>

> If you want to remove the banner, hiding the container view will not
> be enough. You need to call ` Hera.shared.removeBanner()` if you want to show it again you need to `load(adType:action)`

  ##### 2. Interstitial:

To show interstitial ads just call show method on an active view controller like follows:
```swift
self.showAd(ofType: .interstitial, for: adAction, on: self)
```
<br>

> Please note that this method may trigger various events, according to
> the ad showing state, like` didShowAd`, `didFailToShow`,
> `didDismissAd` and so on.

  

### Events

  

Hera may send different events, `HeraDelegate` includes a variety of optional callbacks that you can use to be notified of events, such as when an ad has successfully loaded, or when an ad is about to appear. Refer to the `HeraDelegate` for a list of these methods.

  

## Example

here is an example of all the pieces glued together:

  

```Swift
import  UIKit
import  Hera

enum  AdAction: String {
  case settings
  case mainScreen
}

final class ViewController: UIViewController, HeraDelegate {

override  func  viewWillAppear(_  animated: Bool) {

super.viewWillAppear(animated)

// You need to "ALWAYS" observe in viewDidAppear to keep the observer

// active for only the current visible screen.

Hera.shared.observeEvents(for: self)

loadAd(action: .mainScreen)

}

  

private  func  loadAd(action: AdAction) {

// This func is async and will notify about the result through the delegate

// methods

Hera.shared.loadAd(ofType: .interstitial, action: action.rawValue)

}

func  heraDidLoadAd(for  action: String) {

Hera.shared.showAd(ofType: .interstitial, action: action, on: self)

}

  

func  heraDidFailToLoadAd(for  action: String, error: Error) {

print(error.localizedDescription)

}

  

func  heraDidShowAd(for  action: String) { }

func  heraDidFailToShowAd(for  action: String, error: Error) { }

func  heraDidDismissAd() { }

func  heraDidFailToIntialize(error: Error) { }

  

}

}

```

  

## Updating User Status

  

You can update user properties by passing extraData dictionary to

`Hera.shared.updateUserStatus(extraData:)`

  
  

> Calling this method will fetch the configurations again and re-initialize `Hera`.

  

## Logging

  

Hera uses Xcode console to show different messages, to enable logging pass `HERA_DEBUG_ENABLED` as an argument as follows:

  

**Your_App_Schema > Run > Arguments > Arguments Passed On Launch**

  
## Requirements

- iOS 10.0+
- Swift 5.0+
