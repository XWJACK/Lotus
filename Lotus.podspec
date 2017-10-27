Pod::Spec.new do |s|

  s.name         = "Lotus"
  s.version      = "1.0.1"
  s.summary      = "Easy way to access network"
  s.license 	   = 'MIT'
  s.homepage     = "https://github.com/XWJACK/Lotus"
  s.author       = { "Jack" => "xuwenjiejack@gmail.com" }

  s.ios.deployment_target  = "8.0"
  s.osx.deployment_target = '10.10'

  s.source       = { :git => "https://github.com/XWJACK/Lotus.git", :tag => s.version }

  s.source_files  = ["Source/*.swift"]

  s.requires_arc = true
  s.dependency 'Alamofire', '~> 4.5'
  s.dependency 'SwiftyJSON', '~> 3.1'

  s.preserve_paths = 'Modules/CommonCrypto/**/*'

  s.pod_target_xcconfig = {
    'SWIFT_INCLUDE_PATHS[sdk=iphoneos*]'         => '$(PODS_ROOT)/Lotus/Modules/CommonCrypto/iphoneos',
    'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]'  => '$(PODS_ROOT)/Lotus/Modules/CommonCrypto/iphonesimulator',
    'SWIFT_INCLUDE_PATHS[sdk=macosx*]'           => '$(PODS_ROOT)/Lotus/Modules/CommonCrypto/macosx'
  }
end
