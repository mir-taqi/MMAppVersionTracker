Pod::Spec.new do |spec|
  spec.name         = 'MMAppVersionTracker'
  spec.version      = '0.1.0'
  
 s.description      = <<-DESC
"A very useful and convenient library that tracks App version available on the AppStore so as to prompt user for the updated version."
                       DESC
  spec.authors      = { 'mir-taqi' => 'taqi1435@gmail.com' }
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'https://github.com/mir-taqi/MMAppVersionTracker'
  spec.source       = {
    :git => 'https://github.com/mir-taqi/MMAppVersionTracker.git',
    :branch => 'master',
    :tag => spec.version.to_s
  }
  spec.summary      = 'A simple and easy cocoapod for checking the App remote version on the AppStore'
  spec.source_files = '**/*.swift', '*.swift'
  spec.swift_versions = '4.0'
  spec.frameworks = 'UIKit'
  spec.ios.deployment_target = '11.0'
end
