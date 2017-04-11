Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "SwiftUtilities"
s.summary = "Common Swift utilities."
s.requires_arc = true
s.version = "1.0.0"
s.license = { :type => "Apache-2.0", :file => "LICENSE" }
s.author = { "Hai Pham" => "swiften.svc@gmail.com" }
s.homepage = "https://github.com/protoman92/SwiftUtilities"
s.source = { :git => "https://github.com/protoman92/SwiftUtilities", :tag => "#{s.version}"}
s.framework = "UIKit"
s.dependency 'RxSwift', '~> 3.0'
s.dependency 'RxCocoa', '~> 3.0'
s.dependency 'RxBlocking', '~> 3.0'
s.dependency 'RxTest', '~> 3.0'
s.source_files = "SwiftUtilities/**/*.{swift}"
end
