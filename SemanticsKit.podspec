Pod::Spec.new do |s|
  s.name         = "SemanticsKit"
  s.version      = "0.1.0"
  s.summary      = "Watches over a text view. Finds meaningful parts of the text. Query text tags by index."
  s.homepage     = "http://github.com/shsteven"

  s.license      = 'MIT (example)'

  s.author       = { "Steven Zhang" => "shsteven1000@gmail.com" }

  s.source       = { :git => "git@github.com:shsteven/SemanticsKit.git", :branch => "develop" }

  s.platform     = :ios, '7.0'

  s.source_files = 'SemanticsKit/*.{h,m}'

  s.public_header_files = 'SemanticsKit/*.h'

  s.framework  = 'UIKit'

  s.requires_arc = true

end
