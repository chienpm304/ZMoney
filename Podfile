# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'ZMoney' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Domain', :path => 'Modules/Domain', :testspec => ['Tests']
  pod 'Data', :path => 'Modules/Data'
  pod 'Presentation', :path => 'Modules/Presentation', :testspec => ['Tests']
  pod 'Networking', :path => 'Modules/Networking', :testspec => ['Tests']
  pod 'Common', :path => 'Modules/Common'

  pod 'SwiftLint'

  # POST_INSTALL
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end

end
