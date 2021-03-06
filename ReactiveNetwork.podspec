#
# Be sure to run `pod lib lint ReactiveNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReactiveNetwork'
  s.version          = '0.3.1'
  s.summary          = 'ReactiveNetwork is a small library to allow HTTP network call with RXSwift and parse the JSON result into Swift model object.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ReactiveNetwork is a small library to allow HTTP network call with RXSwift and parse the JSON result into Swift model object.
It provide basic Interceptors to log your request for easy debugging and to set headers globally.
It also provide some basic class for CRUD operation (NetworkDataSource and Repository class).
                       DESC

  s.homepage         = 'https://github.com/jaumard/ReactiveNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jaumard' => 'jimmy.aumard@gmail.com' }
  s.source           = { :git => 'https://github.com/jaumard/ReactiveNetwork.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jaumard'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ReactiveNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ReactiveNetwork' => ['ReactiveNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RxSwift', '~> 4.0'
  s.dependency 'RxCocoa', '~> 4.0'
end
