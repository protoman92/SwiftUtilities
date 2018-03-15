Pod::Spec.new do |s|

    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = "SwiftUtilities"
    s.summary = "Common Swift utilities."
    s.requires_arc = true
    s.version = "1.4.5"
    s.license = { :type => "Apache-2.0", :file => "LICENSE" }
    s.author = { "Hai Pham" => "swiften.svc@gmail.com" }
    s.homepage = "https://github.com/protoman92/SwiftUtilities.git"
    s.source = { :git => "https://github.com/protoman92/SwiftUtilities.git", :tag => "#{s.version}"}
    s.source_files = "SwiftUtilities/**/*.{swift}"
    s.dependency 'SwiftFP', '~> 1.0.0'

    s.subspec 'Main' do |main|
        main.exclude_files = "SwiftUtilities/reactive/*.{swift}"
    end

    s.subspec 'Main+Rx' do |mrx|
        mrx.source_files = "SwiftUtilities/**/*.{swift}"
        mrx.dependency 'RxSwift', '~> 3.0'
        mrx.dependency 'RxCocoa', '~> 3.0'
        mrx.dependency 'RxBlocking', '~> 3.0'
    end

end
