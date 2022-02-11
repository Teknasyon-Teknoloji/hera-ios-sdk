Pod::Spec.new do |s|
  s.name             = 'HeraSDK'
  s.version          = '2.1.0'
  s.summary          = 'An abstraction layer used to manage Ads.'
  
  s.description      = <<-DESC
  Hera is an abstraction layer built on top of another 3rd party ad medation libraries.
  DESC


  s.homepage         = 'https://teknasyon.com'
  s.license          = { :type => 'Commercial', :file => 'LICENSE' }
  s.author           = { 'Teknasyon' => 'https://teknasyon.com' }
  s.source           = { :git => 'https://github.com/Teknasyon-Teknoloji/hera-ios-sdk.git', :tag => s.version.to_s }

  s.default_subspecs = 'ISWrapper', 'Core'
  s.static_framework = true
  s.swift_version = "5.0"
  s.ios.deployment_target = '10.0'

  s.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
  s.user_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.dependency 'IronSourceSDK'

  # Core
  s.subspec 'Core' do |ss|
    ss.dependency 'AMRSDK', '~> 1.4'
    ss.dependency 'AMRAdapterAdmost'
    ss.dependency 'mopub-ios-sdk', '~> 5.18'
    ss.dependency 'Moya'
    ss.dependency 'MoPub-FacebookAudienceNetwork-Adapters'
    ss.dependency 'MoPub-AdMob-Adapters'
    ss.dependency 'AMRAdapterAdmob'
    ss.dependency 'AMRAdapterFacebook'
    ss.source_files = 'Sources/**/*.swift'
    ss.ios.deployment_target = '10.0'
  end

  s.subspec 'ISWrapper' do |ss|
    ss.dependency 'IronSourceSDK', '7.1.12.0'
    ss.source_files = 'Sources/ISWrapper/**/*.*'
    ss.ios.deployment_target = '10.0'
    ss.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/HeraSDK/Sources/ISWrapper $(PODS_TARGET_SRCROOT)/Sources/ISWrapper' }
    ss.preserve_paths = 'Sources/ISWrapper/module.modulemap'
    ss.dependency  'IronSourceAdColonyAdapter'
    ss.dependency  'IronSourceAdMobAdapter'
    ss.dependency  'IronSourceAppLovinAdapter'
    ss.dependency  'IronSourceChartboostAdapter'
    ss.dependency  'IronSourceFacebookAdapter'
    ss.dependency  'IronSourceInMobiAdapter'
    ss.dependency  'IronSourceUnityAdsAdapter'
    ss.dependency  'IronSourceVungleAdapter'
  end

  # IronSource Adapter
  s.subspec 'IronSource' do |ironSource|
    # ironSource.dependency 'AMRAdapterIronsource'
    ironSource.dependency 'MoPub-IronSource-Adapters'
  end

  # UnityAds Adapter
  s.subspec 'UnityAds' do |unityAds|
    unityAds.dependency 'AMRAdapterUnity'
    unityAds.dependency 'MoPub-UnityAds-Adapters'
  end

  # AppLovin Adapter
  s.subspec 'AppLovin' do |appLovin|
    appLovin.dependency 'AMRAdapterApplovin'
    appLovin.dependency 'MoPub-Applovin-Adapters'
  end

   # Chartboost Adapter
   s.subspec 'Chartboost' do |chartboost|
    chartboost.dependency 'AMRAdapterChartboost'
    chartboost.dependency 'MoPub-Chartboost-Adapters'
  end

  # Vungle Adapter
  s.subspec 'Vungle' do |vungle|
    vungle.dependency 'AMRAdapterVungle'
    # vungle.dependency 'MoPub-Vungle-Adapters'
  end

    # TikTok Adapter
  s.subspec 'TikTok' do |tiktok|
    tiktok.dependency 'AMRAdapterTiktok'
    # tiktok.dependency 'MoPub-Pangle-Adapters'
  end
  
  s.subspec 'AdColony' do |ss| 
    ss.dependency 'AMRAdapterAdcolony'
    ss.dependency  'MoPub-AdColony-Adapters'
  end

  s.subspec 'Inmobi' do |ss| 
    ss.dependency 'AMRAdapterInmobi'
    ss.dependency 'MoPub-InMobiMonetization-Adapters'
  end
  
  s.subspec 'Criteo' do |ss|
    ss.dependency 'AMRAdapterCriteo'
  end

  s.subspec 'Pubnative' do |ss|
    ss.dependency 'AMRAdapterPubnative'
    ss.dependency 'MoPub-HyBid-Adapters'
  end

end
