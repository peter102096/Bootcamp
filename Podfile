# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BootcampProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'AFNetworking', '~> 4.0'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'SnapKit', '5.6.0'
  pod 'IQKeyboardManagerSwift', '6.5.10'
  pod 'JGProgressHUD', '2.2'
  pod 'SDWebImage', '~> 5.0'
  pod 'RealmSwift', '10.42.2'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end
  
  target 'BootcampProjectTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BootcampProjectUITests' do
    # Pods for testing
  end

end
