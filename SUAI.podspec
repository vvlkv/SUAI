#
# Be sure to run `pod lib lint SUAI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SUAI'
  s.version          = '1.0.5'
  s.summary          = 'Library for working with SUAI content'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SUAISchedule is a lightweight and simple library for loading and parsing schedule for students and teachers studying in Saint Petersburg State Unversity of Aerospace Instrumentation. It includes both session and semester schedule.
                       DESC

  s.homepage         = 'https://github.com/vvlkv/SUAI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Victor Volkov' => 'vvlkv@icloud.com' }
  s.source           = { :git => 'https://github.com/vvlkv/SUAI.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'SUAI/Classes/**/*'
  s.private_header_files = 'SUAI/Classes/Loader/*.h', 'SUAI/Classes/Parser/*.h', 'SUAI/Classes/Categories/*.h', 'SUAI/Classes/Headers/Links.h'
  s.dependency 'HTMLKit'
end
