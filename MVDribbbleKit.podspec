Pod::Spec.new do |s|
  s.name         = "MVDribbbleKit"
  s.version      = "1.1.0"
  s.summary      = "A modern Objective-C wrapper for the Dribbble API."

  s.description  = <<-DESC
                   MVDribbbleKit is a modern, full-featured and well-documented 
                   Objective-C wrapper for the official [Dribbble API](https://dribbble.com/api).
                   DESC

  s.homepage     = "https://github.com/marcelvoss/MVDribbbleKit"
  s.license      = 'MIT'
  s.author             = { "Marcel Voss" => "hello@marcelvoss.com" }
  s.social_media_url   = "http://twitter.com/CocoaMarcel"
  s.source       = { :git => "https://github.com/marcelvoss/MVDribbbleKit.git", :tag => s.version }
  
  s.source_files  = "MVDribbbleKit", "MVDribbbleKit/**/*.{h,m}"

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'

  s.requires_arc = true
end
