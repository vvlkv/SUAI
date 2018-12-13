#
# Be sure to run `pod lib lint SUAISchedule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SUAISchedule'
  s.version          = '0.1.5'
  s.summary          = 'Library for working with SUAI schedule'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SUAISchedule is a lightweight and simple library for loading and parsing schedule for students and teachers studying in Saint Petersburg State Unversity of Aerospace Instrumentation. It includes both session and semester schedule.
                       DESC

  s.homepage         = 'https://github.com/vvlkv/SUAISchedule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Victor Volkov' => 'vvlkv@icloud.com' }
  s.source           = { :git => 'https://github.com/vvlkv/SUAISchedule.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'SUAISchedule/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SUAISchedule' => ['SUAISchedule/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'HTMLKit'
end
