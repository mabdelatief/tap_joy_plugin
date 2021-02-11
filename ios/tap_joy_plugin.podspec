#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tap_joy_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tap_joy_plugin'
  s.version          = '0.0.5'
  s.summary          = 'Flutter Plugin for TapJoy SDK'
  s.description      = <<-DESC
Flutter Plugin for TapJoy SDK
                       DESC
  s.homepage         = 'https://github.com/mabdelatief'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mahmoud Abdellatief' => 'm.abdelatief@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'TapjoySDK'
  s.platform = :ios, '9.0'
  s.static_framework = true


  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
