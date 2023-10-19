# Uncomment the next line to define a global platform for your project
  #platform :ios, '11.0'

target 'BrokeBet' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BrokeBet
  pod "BottomHalfModal"
  pod 'IQKeyboardManagerSwift'
  pod 'CurrencyText'
  pod 'lottie-ios'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'SnapKit', '~> 5.6.0'
  pod 'Charts'

  target 'BrokeBetTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BrokeBetUITests' do
    # Pods for testing
  end

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end
