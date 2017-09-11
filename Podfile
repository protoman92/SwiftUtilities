# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def allPods
    pod 'RxSwift', '~> 3.0'
    pod 'RxCocoa', '~> 3.0'
    pod 'RxBlocking', '~> 3.0'
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
    pod 'RxBlocking', '~> 3.0'
    pod 'RxTest', '~> 3.0'
  end

end
