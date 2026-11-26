Pod::Spec.new do |s|
  s.name          = 'GeniusSDKFramework'
  s.version       = '1.2.0'
  s.summary       = 'GeniusSDK Framework Pod'
  s.homepage      = 'https://github.com/socal-ltd/GeniusSDKFramework'
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = 'Eshkol'
  s.source        = { :git => 'https://github.com/socal-ltd/GeniusSDKFramework.git', :tag => "prod-v#{s.version}" }
  s.swift_version = '5.0'

  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '14.0'
  s.osx.deployment_target = '12.0'

  s.ios.frameworks = 'Foundation', 'UIKit', 'AdSupport', 'Network', 'WebKit'
  s.ios.weak_frameworks = 'AppTrackingTransparency', 'AdServices'
  s.osx.frameworks = 'Foundation', 'AppKit', 'AdServices', 'AdSupport', 'AppTrackingTransparency', 'IOKit', 'Network', 'WebKit'
  s.tvos.frameworks = 'Foundation', 'UIKit', 'AdSupport', 'AppTrackingTransparency', 'Network'

  s.vendored_frameworks = 'GeniusSDKFramework.xcframework'
end
