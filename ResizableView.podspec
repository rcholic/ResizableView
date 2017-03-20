#
# Be sure to run `pod lib lint ResizableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ResizableView'
  s.version          = '0.1.0'
  s.summary          = 'An iOS library for making user-resizable UIView objects'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/rcholic/ResizableView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rcholic' => 'ivytony@gmail.com' }
  s.source           = { :git => 'https://github.com/rcholic/ResizableView.git', :tag => s.version.to_s }


  s.ios.deployment_target = '10.0'
  s.requires_arc = true
  s.source_files = 'Sources/*'
  s.frameworks = 'UIKit'  

end
