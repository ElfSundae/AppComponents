Pod::Spec.new do |s|
  s.name              = "APIService-XGPush"
  s.version           = "2.5.0"
  s.summary           = "Tencent XG Push Service SDK."
  s.homepage          = "https://github.com/ElfSundae/AppComponents"
  s.documentation_url = "http://developer.qq.com/wiki/xg"
  s.authors           = {
    "Tencent" => "http://xg.qq.com"
  }
  s.license           = {
    :type => "Copyright",
    :text => "Copyright http://xg.qq.com"
  }
  s.source            = {
    :http => "http://xg.qq.com/pigeon_v2/resource/sdk/Xg-Push-SDK-iOS-2.5.0.zip"
  }
  s.platform          = :ios, "6.0"
  s.frameworks        = "SystemConfiguration", "CoreTelephony"
  s.weak_framework    = "UserNotifications"
  s.libraries         = "z"

  s.source_files      = "**/XGPush.h", "**/XGSetting.h"
  s.vendored_libraries = "**/libXG-SDK.a"
end
