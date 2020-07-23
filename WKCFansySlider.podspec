Pod::Spec.new do |s|
s.name         = "WKCFansySlider"
s.version      = "0.1.2"
s.summary      = "可高度自定义的滑块视图"
s.homepage     = "https://github.com/WKCLoveYang/WKCFansySlider.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WKCLoveYang" => "wkcloveyang@gmail.com" }
s.platform     = :ios, "10.0"
s.source       = { :git => "https://github.com/WKCLoveYang/WKCFansySlider.git", :tag => "0.1.2" }
s.source_files  = "WKCFansySlider/**/*.swift"
s.requires_arc = true
s.swift_version = "5.0"

end
