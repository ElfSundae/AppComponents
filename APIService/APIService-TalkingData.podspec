Pod::Spec.new do |s|
  s.name              = "APIService-TalkingData"
  s.version           = "2.2.24.1"
  s.summary           = "TalkingData Analytics SDK for iOS."
  s.homepage          = "https://www.talkingdata.com"
  s.authors           = { "TalkingData" => "https://www.talkingdata.com" }
  s.license           = { :type => "MIT", :text => "Copyright https://www.talkingdata.com" }
  s.source            = { :http => "http://www.tenddata.com:8080/download/TalkingData_Analytics_iOS_SDK_V2.2.24.zip" }
  s.platform          = :ios
  s.ios.deployment_target = "6.0"
  s.frameworks        = "Security", "SystemConfiguration", "CoreTelephony", "CoreMotion", "AdSupport"
  s.libraries         = "z"
  s.source_files      = "**/TalkingData.h", "**/TalkingDataSMS.h"
  s.preserve_paths    = "**/libTalkingData.a"
  s.vendored_libraries = "**/libTalkingData.a"
end
