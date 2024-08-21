
Pod::Spec.new do |s|
  s.name             = "NetworkingModule"
  s.version          = "1.0.0"
  s.summary          = "Networking Module"
  s.description      = <<-DESC
                       Networking Module
                       DESC

  s.homepage         = "https://github.com/chienpm304/ZMoney"
  s.author           = { "Chien Pham" => "https://github.com/chienpm304" }
  s.source           = { :git => "https://github.com/chienpm304/ZMoney.git", :tag => "v#{s.version}" }

  s.ios.deployment_target = '13.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.3' }

  s.source_files = 'NetworkingModule/**/*.{m,h,swift}'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'NetworkingModuleTests/**/*.{m,h,swift}'
  end 

  s.dependency 'CommonModule'

end
