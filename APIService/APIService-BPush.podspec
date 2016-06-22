Pod::Spec.new do |s|
  s.name              = "APIService-BPush"
  s.version           = "1.4.5"
  s.summary           = "Baidu push SDK. http://push.baidu.com"
  s.homepage          = "https://github.com/ElfSundae/AppComponents"
  s.documentation_url = "http://push.baidu.com/doc/ios/api"
  s.authors           = {
    "Baidu" => "http://push.baidu.com"
  }
  s.license           = {
    :type => "Copyright",
    :text => "Copyright http://push.baidu.com"
  }
  s.source            = {
    :http => "http://boscdn.bpc.baidu.com/channelpush/sdk/BPush-SDK-iOS-1.4.5.zip"
  }
  s.platform          = :ios, "5.1"
  s.frameworks        = "SystemConfiguration", "CoreTelephony"
  s.libraries         = "z"

  s.default_subspec   = "IDFA"
  s.subspec "IDFA" do |ss|
    ss.frameworks             = "AdSupport"
    ss.source_files           = "**/idfaversion/BPush.h"
    ss.vendored_libraries     = "**/idfaversion/libBPush.a"
  end
  s.subspec "Normal" do |ss|
    ss.source_files           = "**/normalversion/BPush.h"
    ss.vendored_libraries     = "**/normalversion/libBPush.a"
  end
end
