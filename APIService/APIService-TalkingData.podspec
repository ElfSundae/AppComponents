Pod::Spec.new do |s|
  s.name              = "APIService-TalkingData"
  s.version           = "2.2.24.2"
  s.summary           = "TalkingData Analytics SDK."
  s.homepage          = "https://github.com/ElfSundae/AppComponents/tree/master/APIService/APIService-TalkingData.podspec"
  s.social_media_url  = "https://twitter.com/ElfSundae"
  s.authors           = { "TalkingData" => "https://www.talkingdata.com" }
  s.license           = { :type => "Copyright", :text => "Copyright https://www.talkingdata.com" }
  s.source            = { :http => "http://www.tenddata.com:8080/download/TalkingData_Analytics_iOS_SDK_V2.2.24.zip" }
  s.platform          = :ios
  s.ios.deployment_target = "6.0"
  s.frameworks        = "Security", "SystemConfiguration", "CoreTelephony", "CoreMotion", "AdSupport"
  s.libraries         = "z"
  s.source_files      = "**/TalkingData.h", "**/TalkingDataSMS.h"
  s.vendored_libraries = "**/libTalkingData.a"
end
