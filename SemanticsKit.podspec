Pod::Spec.new do |s|
  s.name         = "SemanticsKit"
  s.version      = "0.1.0"
  s.summary      = "Watches over a text view. Finds meaningful parts of the text. Query text tags by index."
  s.homepage     = "http://github.com/shsteven"

  # Specify the license type. CocoaPods detects automatically the license file if it is named
  # 'LICENCE*.*' or 'LICENSE*.*', however if the name is different, specify it.
  s.license      = 'MIT (example)'
  # s.license      = { :type => 'MIT (example)', :file => 'FILE_LICENSE' }

  # Specify the authors of the library, with email addresses. You can often find
  # the email addresses of the authors by using the SCM log. E.g. $ git log
  #
  s.author       = { "Steven Zhang" => "shsteven1000@gmail.com" }

  # Specify the location from where the source should be retrieved.
  #
  s.source       = { :path => "~/Dropbox/Components/SemanticsKit", :branch => "develop" }

  s.platform     = :ios, '7.0'

  s.source_files = 'SemanticsKit/*.{h|m}'

  s.public_header_files = 'SemanticsKit/*.h'

  s.framework  = 'UIKit'

  s.requires_arc = true

end
