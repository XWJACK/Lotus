Pod::Spec.new do |s|

  s.name         = "Lotus"
  s.version      = "1.0.1"
  s.summary      = "Easy Way to Access Network"
  s.license 	 = 'MIT'
  s.homepage     = "https://github.com/XWJACK/Lotus"
  s.author       = { "Jack" => "xuwenjiejack@gmail.com" }

  s.ios.deployment_target  = "8.0"
  s.osx.deployment_target = '10.10'

  s.source       = { :git => "https://github.com/XWJACK/Lotus.git", :tag => s.version }

  s.source_files  = ["Source/*.swift"]
  s.public_header_files = ["Sources/Lotus.h"]

  s.requires_arc = true
  s.dependency 'Alamofire', '~> 4.5'
  s.dependency 'SwiftyJSON', '~> 3.1'
end
