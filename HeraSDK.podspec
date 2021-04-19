Pod::Spec.new do |s|
  s.name             = 'HeraSDK'
  s.version          = '1.3.3'
  s.summary          = 'An abstraction layer used to manage Ads.'
  
  s.description      = <<-DESC
  Hera is an abstraction layer built on top of another 3rd party ad medation libraries.
  DESC

  s.homepage         = 'https://teknasyon.com'
  s.license          = { :type => 'Commercial', :file => 'LICENSE' }
  s.author           = { 'Teknasyon' => 'https://teknasyon.com' }
  s.source           = { :git => 'https://github.com/Teknasyon-Teknoloji/hera-ios-sdk.git', :tag => s.version.to_s }

  s.static_framework = true
  s.swift_version = "5.0"
  s.ios.deployment_target = '10.0'

  s.default_subspec = 'Core'
  s.static_framework = true
  s.swift_version = "5.0"

  s.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
  s.user_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }

  # Core
  s.subspec 'Core' do |ss|
    ss.dependency 'AMRSDK', '~> 1.4'
    ss.dependency 'AMRAdapterAdmost'
    ss.dependency 'mopub-ios-sdk', '5.16.2'
    ss.dependency 'Moya'
    ss.dependency 'MoPub-FacebookAudienceNetwork-Adapters'
    ss.dependency 'MoPub-AdMob-Adapters'
    ss.dependency 'AMRAdapterAdmob'
    ss.dependency 'AMRAdapterFacebook'
    ss.source_files = 'Sources/**/*.*'
    ss.ios.deployment_target = '10.0'
  end

  # IronSource Adapter
  s.subspec 'IronSource' do |ironSource|
    ironSource.dependency 'AMRAdapterIronsource'
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
    vungle.dependency 'MoPub-Vungle-Adapters'
  end

end
