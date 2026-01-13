Pod::Spec.new do |s|
  s.name          = 'GeniusSDKFramework'
  s.version       = '1.0.11'
  s.summary       = 'GeniusSDK Framework Pod'
  s.homepage      = 'https://github.com/socal-ltd/GeniusSDKFramework'
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = 'Eshkol'
  s.source        = { :git => 'https://github.com/socal-ltd/GeniusSDKFramework.git', :tag => "prod-v#{s.version}" }
  s.platform     = :ios, :tvos, :osx
  s.swift_version = '5.0'
  
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '14.0'
  s.osx.deployment_target = '12.0'
  
  s.ios.frameworks = 'UIKit', 'AppTrackingTransparency', 'AdSupport', 'Foundation'
  s.osx.frameworks = 'Foundation', 'AppTrackingTransparency', 'AdSupport', 'AppKit', 'IOKit'
  s.tvos.frameworks = 'Foundation', 'AppTrackingTransparency', 'AdSupport', 'UIKit'

  s.vendored_frameworks = 'GeniusSDKFramework.xcframework'
end
