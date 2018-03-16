# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def allPods
    pod 'RxSwift', '~> 4.0'
    pod 'RxCocoa', '~> 4.0'
    pod 'RxBlocking', '~> 4.0'
    pod 'SwiftFP', :git => 'https://github.com/protoman92/SwiftFP.git'
end

target 'SwiftUtilities' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SwiftUtilities
  allPods

  target 'SwiftUtilitiesTests' do
    inherit! :search_paths
    # Pods for testing
    allPods
    pod 'RxTest', '~> 4.0'
  end

end
