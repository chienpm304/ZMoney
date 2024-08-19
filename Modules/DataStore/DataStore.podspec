
Pod::Spec.new do |s|
  s.name             = "DataStore"
  s.version          = "1.0.0"
  s.summary          = "Data Module"
  s.description      = <<-DESC
Data Module
                       DESC

  s.homepage         = "https://github.com/chienpm304/ZMoney"
  s.author           = { "Chien Pham" => "https://github.com/chienpm304" }
  s.source           = { :git => "https://github.com/chienpm304/ZMoney.git", :tag => "v#{s.version}" }

  s.ios.deployment_target = '13.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  s.source_files = 'DataStore/**/*.{m,h,swift}'
  s.resource_bundles    = {
    "ZMoney-CoreData" => ["DataStore/Local/CoreData/*.xcdatamodeld"],
  }

  s.dependency 'Domain'
  s.dependency 'Networking'
  s.dependency 'Common'

end