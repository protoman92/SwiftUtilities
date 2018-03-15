Pod::Spec.new do |s|

    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = "SwiftUtilitiesTests"
    s.summary = "Common Swift test utilities."
    s.requires_arc = true
    s.version = "1.4.5"
    s.license = { :type => "Apache-2.0", :file => "LICENSE" }
    s.author = { "Hai Pham" => "swiften.svc@gmail.com" }
    s.homepage = "https://github.com/protoman92/SwiftUtilities.git"
    s.source = { :git => "https://github.com/protoman92/SwiftUtilities.git", :tag => "#{s.version}"}
    s.source_files = "SwiftUtilitiesTests/{mock,util}/**/*.{swift}"

    s.subspec 'Main' do |main|
    end

    s.subspec 'Main+Rx' do |mrx|
        s.dependency 'RxSwift', '~> 3.0'
        s.dependency 'RxCocoa', '~> 3.0'
        s.dependency 'RxTest', '~> 3.0'
        s.dependency 'RxBlocking', '~> 3.0'
    end
end
