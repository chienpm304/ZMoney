
Pod::Spec.new do |s|
  s.name             = "DataModule"
  s.version          = "1.0.0"
  s.summary          = "Data Module"
  s.description      = <<-DESC
                       Data Module
                       DESC

  s.homepage         = "https://github.com/chienpm304/ZMoney"
  s.author           = { "Chien Pham" => "https://github.com/chienpm304" }
  s.source           = { :git => "https://github.com/chienpm304/ZMoney.git", :tag => "v#{s.version}" }

  s.ios.deployment_target = '13.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.3' }

  s.source_files = 'DataModule/**/*.{m,h,swift,xcdatamodeld}'
  s.resource_bundles    = {
    "CoreData" => ["DataModule/Local/CoreData/*.xcdatamodeld"],
  }

  s.dependency 'DomainModule'
  s.dependency 'NetworkingModule'

end
