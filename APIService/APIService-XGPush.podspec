Pod::Spec.new do |s|
  s.name              = "APIService-XGPush"
  s.version           = "2.4.6.2"
  s.summary           = "Tencent XG Push Service SDK."
  s.homepage          = "https://github.com/ElfSundae/AppComponents/tree/master/APIService/APIService-XGPush.podspec"
  s.social_media_url  = "https://twitter.com/ElfSundae"
  s.authors           = { "Tencent" => "http://xg.qq.com" }
  s.license           = { :type => "Copyright", :text => "Copyright http://xg.qq.com" }
  s.source            = { :http => "http://xg.qq.com/pigeon_v2/resource/sdk/Xg-Push-SDK-iOS-2.4.6.zip" }
  s.platform          = :ios
  s.ios.deployment_target = "6.0"
  s.frameworks        = "Security", "SystemConfiguration", "CoreTelephony", "CFNetwork"
  s.libraries         = "z", "sqlite3"
  s.source_files      = "**/XGPush.h", "**/XGSetting.h"
  s.vendored_libraries = "**/libXG-SDK.a"
end
