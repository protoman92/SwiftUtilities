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

    s.subspec 'Main' do |main|
				main.source_files = "SwiftUtilitiesTests/{mock,util}/**/*.{swift}"
      	main.exclude_files = "SwiftUtilitiesTests/mock/rx/**/*.{swift}"
    end

    s.subspec 'Main+Rx' do |mrx|
				mrx.source_files = "SwiftUtilitiesTests/{mock,util}/**/*.{swift}"
        mrx.dependency 'RxSwift', '~> 4.0'
        mrx.dependency 'RxCocoa', '~> 4.0'
        mrx.dependency 'RxTest', '~> 4.0'
        mrx.dependency 'RxBlocking', '~> 4.0'
    end
end
