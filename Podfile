#use_frameworks!
 #:linkage => :static
platform :ios, '10.0'
#source 'https://cdn.cocoapods.org/'
source 'https://github.com/CocoaPods/Specs.git'
source 'git@bitbucket.org:teknasyonteknoloji/ares-pods.git'

project './Hera.xcodeproj'
use_frameworks!

target 'Hera' do
 
    pod 'AMRSDK'
    pod 'AMRAdapterAdmob'#, '~> 7.69'
    pod 'AMRAdapterAdmost'#, '~> 1.4'
    pod 'AMRAdapterFacebook'#, '~> 6.2'
    pod 'Google-Mobile-Ads-SDK'

    pod 'mopub-ios-sdk'#, '5.16.2'
    pod 'MoPub-FacebookAudienceNetwork-Adapters'
    pod 'MoPub-AdMob-Adapters'
    pod 'Moya'
    pod 'IronSourceSDK' 
end

target 'HeraTests' do
    use_frameworks!
    inherit! :complete
    # Pods for testing
end

target 'HeraExample' do 
    pod 'Alamofire'
    pod 'IronSourceSDK' 
end

target 'ISWrapper' do 
    pod 'IronSourceSDK' 
end