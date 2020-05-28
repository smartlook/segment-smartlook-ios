Pod::Spec.new do |s|
    s.name             = "Segment-Smartlook"
    s.version          = "0.1.0"
    s.summary          = "Smartlook Integration for Analytics for iOS."
  
    s.description      = <<-DESC
                        Analytics for iOS provides a single API that lets you integrate with other tools.

                        Smartlook records users on websites and in mobile apps. 
                        Understand how people use your app, figure out where they are struggling and pinpoint issues in conversions.

                        DESC
  
    s.homepage         = "https://github.com/smartlook/segment-smartlook-ios"
    s.license          = 'MIT'
    s.author           = { "Smartlook" => "support@smartlook.com" }
    s.source           = { :git => "https://github.com/smartlook/segment-smartlook-ios.git", :branch => "devel" } #:tag => s.version.to_s }
  
    s.platform     = :ios, '8.0'
    s.requires_arc = true
  
    s.source_files = 'Pod/Classes/**/*'

    s.static_framework = true
  
    s.dependency 'Analytics'
    s.dependency 'Smartlook'
  end