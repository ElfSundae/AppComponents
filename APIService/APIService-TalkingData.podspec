Pod::Spec.new do |s|
  s.name              = "APIService-TalkingData"
  s.version           = "2.2.28"
  s.summary           = "TalkingData Analytics SDK. https://www.talkingdata.com"
  s.homepage          = "https://github.com/ElfSundae/AppComponents"
  s.documentation_url = "http://doc.talkingdata.com/posts/20"
  s.authors           = { "TalkingData" => "https://www.talkingdata.com" }
  s.license           = { :type => "Copyright", :text => "Copyright https://www.talkingdata.com" }
  s.source            = { :http => "http://www.tenddata.com:8080/download/TalkingData_Analytics_iOS_SDK.zip" }
  s.platform          = :ios, "6.0"
  s.frameworks        = "Security", "SystemConfiguration", "CoreTelephony", "CoreMotion", "AdSupport"
  s.libraries         = "z"
  s.source_files      = "**/TalkingData.h", "**/TalkingDataSMS.h"
  s.vendored_libraries = "**/libTalkingData.a"
end
