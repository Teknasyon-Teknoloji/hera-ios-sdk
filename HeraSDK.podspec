Pod::Spec.new do |s|
  s.name             = 'HeraSDK'
  s.version          = '1.3.1'
  s.summary          = 'An abstraction layer used to manage Ads.'
  
  s.description      = <<-DESC
  Hera is an abstraction layer built on top of another 3rd party ad medation libraries.
  DESC

  s.homepage         = 'https://teknasyon.com'
  s.license          = { :type => 'Commercial', :file => 'LICENSE' }
  s.author           = { 'Teknasyon' => 'https://teknasyon.com' }
  s.source           = { :git => 'https://github.com/Teknasyon-Teknoloji/hera-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.static_framework = true
  s.source_files = 'Sources/**/*.*'
  s.swift_version = "5.0"

  s.dependency 'AMRSDK', '~> 1.4'
  s.dependency 'AMRAdapterAdmob'
  s.dependency 'AMRAdapterFacebook'
  s.dependency 'AMRAdapterAdmost'
  
  s.dependency 'mopub-ios-sdk', '5.16.2'
  s.dependency 'MoPub-FacebookAudienceNetwork-Adapters'
  s.dependency 'MoPub-AdMob-Adapters'
  
  s.dependency 'Moya'

  s.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
  s.user_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }

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
