Pod::Spec.new do |s|

    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = "SwiftUtilities"
    s.summary = "Common Swift utilities."
    s.requires_arc = true
    s.version = "1.0.4"
    s.license = { :type => "Apache-2.0", :file => "LICENSE" }
    s.author = { "Hai Pham" => "swiften.svc@gmail.com" }
    s.homepage = "https://github.com/protoman92/SwiftUtilities.git"
    s.source = { :git => "https://github.com/protoman92/SwiftUtilities.git", :tag => "#{s.version}"}
    s.framework = "UIKit"
    s.dependency 'RxSwift', '~> 3.0'
    s.dependency 'RxCocoa', '~> 3.0'

    s.subspec 'Main' do |main|
        main.source_files = "SwiftUtilities/**/*.{swift}"
    end

end
