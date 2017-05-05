Pod::Spec.new do |s|

  s.name         = "Lotus"
  s.version      = "0.1.0"
  s.summary      = "XWJACK Network Library"

  s.homepage     = "https://github.com/XWJACK/Lotus"
  s.author       = { "Jack" => "xuwenjiejack@gmail.com" }

  s.ios.deployment_target  = "8.0"

  s.source       = { :git => "https://github.com/XWJACK/Lotus.git", :tag => s.version }

  s.source_files  = ["Sources/*.swift"]
  s.public_header_files = ["Sources/Lotus.h"]

  s.requires_arc = true

end
