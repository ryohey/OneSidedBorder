Pod::Spec.new do |s|
  s.name             = 'OneSidedBorder'
  s.version          = '0.1.0'
  s.summary          = 'Extension to add borders to a UIView.'

  s.description      = <<-DESC
Extension to add borders to a UIView .
                       DESC

  s.homepage         = 'https://github.com/ryohey/OneSidedBorder'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ryohey' => 'info@codingcafe.jp' }
  s.source           = { :git => 'https://github.com/ryohey/OneSidedBorder.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'OneSidedBorder/Classes/**/*'
  s.frameworks = 'UIKit'
end
