#
# Be sure to run `pod lib lint ReactiveNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReactiveNetwork'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ReactiveNetwork.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fa35de542d80347b4a3940d4945d1685503dec3d/ReactiveNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fa35de542d80347b4a3940d4945d1685503dec3d' => 'Jimmy.Aumard@nestle.com' }
  s.source           = { :git => 'https://github.com/fa35de542d80347b4a3940d4945d1685503dec3d/ReactiveNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ReactiveNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ReactiveNetwork' => ['ReactiveNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
