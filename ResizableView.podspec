#
# Be sure to run `pod lib lint ResizableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ResizableView'
  s.version          = '0.2.0'
  s.summary          = 'An iOS library for making user-resizable UIView objects'

  s.description      = 'This library allows iOS app developer to create user resizable UIView objects such as UIView and UIImageView. The user will be able to resize and move these objects by dragging them on the screen'

  s.homepage         = 'https://github.com/rcholic/ResizableView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rcholic' => 'ivytony@gmail.com' }
  s.source           = { :git => 'https://github.com/rcholic/ResizableView.git', :tag => s.version.to_s }


  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'Source/**/*'
  s.frameworks = 'UIKit'  

end
