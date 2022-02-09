# Hera

Hera strives to simplify the process of integrating and remotely configuring 3rd party ads libraries in your project, here a list of the features it provides:

## Features

* ✅ Remotely changing the ad unit id associated with a specific action.

* 🚀 Changing the ads provider on the fly.

* ⏰ Control the ads showing intervals remotly.

* ⚙️ Showing ads based on a specific action.

## Register Your App

First thing first, before you go further with the SDK integration, you need to register your app in the Hera panel and get the corresponding app ID.

The following document offers a quick guide on how to use this SDK.

## Ad Networks

Hera supports Google Admob and Facebook Ads out of the box if you would like to integrate other ad networks please refer to their [integration guide](https://github.com/Teknasyon-Teknoloji/hera-ios-sdk/blob/master/NETWORKS.md).

## Installation

Once you are done with the app registration, you are ready to proceed with the SDK integration into your app.

Hera is available through [CocoaPods](http://cocoapods.org/) only. To install it, simply add the following line to your Podfile:

```ruby

pod 'HeraSDK'

```

  

## Usage

### Initialization

To initialize Hera you need to collect advertise attributions first. The advertise attribution is a simple dictionary of type `[String: Codable]`

here is an example of how it look like

```swift

["adjust": "{\"trackerToken\":\"xxx\",\"adid\":\"xxxxx\",\"trackerName\":\"Organic\",\"network\":\"Organic\"}"]

```

#### HeraUserProperties

After preparing `AddvertisementAttributions` we can initialize `HeraUserProperties` like follows

```swift
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

Get the app-specific api key. Hera supports both `sandbox` and `production` environments depending on whether you build your app for testing or production you must set the it accordingly.

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

**2. (Optional)** By the same token some ads content might need to access user's calendar so you may need calendar access permission

```xml
<key>NSCalendarsUsageDescription</key>
<string>Some ad content may access calendar</string>
```

**3.**  **You must add your AdMob App ID, and Facebook App ID to your plist file with as shown below**. **Otherwise the app will crash.**

```xml
<key>GADApplicationIdentifier</key>
<string>YOUR_ADMOB_APP_KEY_HERE</string>
<key>FacebookAppID</key>
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
// ...

if #available(iOS  14.5, *) {
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

## Ads

Once you are done with the integration of the Hera SDK it is time now to load and show some ads. Hera support different types of ads formats like `interstail` , `banner` , `native` and `rewarded` .

To show ads in your app please follow the following steps:

#### 1. Make your view controller as A delegate

To listen for various Hera events, first import Hera then register for notifications by conforming to `HeraDelegate` and calling:

```swift
Hera.shared.observeEvents(on: self)
```

> Please start observing in viewWillAppear method not viewDidLoad to make sure you always listen for event in the current visible view controller.

To remove the observer, you can use removeObserver method.

```swift
Hera.shared.removeObserver(from: self)
```

#### 2. Loading  and Showing Ads

  
To load ads call loadAd(ofType:action:). Please note that this method is async and it will trigger various events according to the load result. To see all the available events check `Events` section.

#####  Interstitial Ads

Interstitial ads provide full-screen experiences, commonly incorporating rich media to offer a higher level of interactivity than banner ads.

You can load  interstitial ads  by calling the following method:

```swift
Hera.shared.loadAd(ofType: .interstitial, for: "settings")
```

The load method will trigger various events according to the load result, you can use `heraDidLoadAd(for action: String, adType: AdType)` to check if the ad loaded successfully if so you can show it like follows.

```swift
self.showAd(ofType: .interstitial, for: adAction, on: yourViewController)
```

> Please note that this method may trigger various events, according to
> the ad showing state, like ` didShowAd` , `didFailToShow` , 
> `didDismissAd` and so on.

 #####  Banner Ads
 Banner ads usually appear at the top or bottom of your app’s screen. Adding one to your app takes just a few lines of code.
 
To load a banner ad all you need to do is just calling load method, again this method will trigger various events according to the load result.

```swift
Hera.shared.loadAd(ofType: .banner, for: "inAppSwipe")
```

If the load is successful you can show the banner but before trying to show it there are extra steps you need to do:

 1. Define a container view that will hold the banner.
 2. Give it the required constraints (The standard size of a banner is 320 x 50)
 3. Add to your super view(if you use layout in code)  
 4. Then call show method like follows:

```swift
Hera.shared.showAd(ofType: .banner, for: adAction, on: bannerContainerView)
 ```

> Please make sure that the banner container view is visible and has a valid frame before trying to call this method.

 #####  Rewarded Ads
 Rewarded ads are a great way to keep users engaged in your app while earning ad revenue. The reward generally comes in the form of in-game currency (gold, coins, power-ups, etc.) and is distributed to the user after a successful ad completion.
 
You can load  rewarded ads  by calling the following method:

```swift
Hera.shared.loadAd(ofType: .rewarded, for: "playerScreen")
```

Again, this load method will trigger various events according to the load result, it works almost the same way like interstitial ads so you can present it on any visible view controller like follows

```swift
Hera.shared.showAd(ofType: .rewarded, for: adAction, on: yourViewController)
```

When the user finishes watching the ad til the end `heraDidRewardUser` will be called so you can reward the user according to that.

 #####  Native Ads
Native ads let you monetize your app in a way that’s consistent with its existing design. Hera gives you access to an ad’s individual assets so you can design the ad layout to be consistent with the look and feel of your app.

###### Step1: Define Your Ad Layout

1. Create or Use one of the custom XIBs to design your ad layout
2. Set the `File Owner` of your XIB to `DefaultNativeRenderer`

3. Connect the `IBOutlets` If necessary.

Once you are done with the ad layout design you can load  native ads  by calling the following method:

```swift
let config = NativeAdConfig(
	nibName: "YOUR_XIB_NAME",
	size: nativeAdSize,
	indexPath: indexPath // optional to help you keep trackingon which cell you requested the ad.
)
Hera.shared.loadAd(ofType: .native(config: config), action: "nativeAction")
```

To get the loaded ad you can retrieve it from the config like follows:

 

```swift
   func heraDidLoadAd(for action: String, adType: AdType) {
		switch adType {
		...
		case .native(let config):
			guard let adView = config.retrieveAdView() else { return }
			// show the ad
		}
	}
```

### Events

Hera may send different events, `HeraDelegate` includes a variety of optional callbacks that you can use to be notified of events, such as when an ad has successfully loaded, or when an ad is about to appear. Refer to the `HeraDelegate` for a list of these methods.
  

## Updating User Status

You can update user properties by passing extraData dictionary to
 `Hera.shared.updateUserStatus(extraData:)`

> Calling this method will fetch the configurations again and re-initialize `Hera` .

## Logging

Hera uses Xcode console to show different messages, to enable logging pass `HERA_DEBUG_ENABLED` as an argument as follows:

**Your_App_Schema > Run > Arguments > Arguments Passed On Launch**

## Requirements

* iOS 10.0+
* Swift 5.0+

## FAQs

Why the ad is not loaded?

* There are many reasons for that, the ad requests may fail due to lack of inventory or connectivity issues. check the console log for more verbose info.
