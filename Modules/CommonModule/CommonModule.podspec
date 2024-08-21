
Pod::Spec.new do |s|
    s.name             = "CommonModule"
    s.version          = "1.0.0"
    s.summary          = "Common Module"
    s.description      = <<-DESC
                         Common Module
                         DESC
  
    s.homepage         = "https://github.com/chienpm304/ZMoney"
    s.author           = { "Chien Pham" => "https://github.com/chienpm304" }
    s.source           = { :git => "https://github.com/chienpm304/ZMoney.git", :tag => "v#{s.version}" }
  
    s.ios.deployment_target = '13.0'
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.3' }
  
    s.source_files = 'CommonModule/**/*.{m,h,swift}'
  
  end
  