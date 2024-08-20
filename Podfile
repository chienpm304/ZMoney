# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'ZMoney' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Domain', :path => 'Modules/Domain', :testspec => ['Tests']
  pod 'DataStore', :path => 'Modules/DataStore'
  pod 'Networking', :path => 'Modules/Networking', :testspec => ['Tests']
  pod 'Common', :path => 'Modules/Common'

  # Temporary moved Presentation module to main app because Xcode preview doesnot work 
  # for static library

  pod 'SwiftLint'

  # POST_INSTALL
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        config.build_settings['CODE_SIGN_IDENTITY'] = ""
      end
    end
  end

end
