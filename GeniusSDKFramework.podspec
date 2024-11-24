Pod::Spec.new do |s|
  s.name          = 'GeniusSDKFramework'
  s.version       = '1.0.1'
  s.summary       = 'GeniusSDK Framework Pod'
  s.homepage      = 'https://www.eshkol.com'
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = 'Eshkol'
  s.source        = { :git => 'https://github.com/socal-ltd/GeniusSDKFramework.git', :tag => s.version.to_s }
  s.platform     = :ios, :tvos, :osx
  s.swift_version = '5.0'
  
  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '14.0'
  s.osx.deployment_target = '12.0'
  
  s.ios.frameworks = 'UIKit', 'AppTrackingTransparency', 'AdSupport', 'Foundation'
  s.osx.frameworks = 'Foundation', 'AppTrackingTransparency', 'AdSupport', 'AppKit', 'IOKit'
  s.tvos.frameworks = 'Foundation', 'AppTrackingTransparency', 'AdSupport', 'UIKit'

  s.vendored_frameworks = 'GeniusSDKFramework.xcframework'
end
