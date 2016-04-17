Pod::Spec.new do |s|
  s.name              = "APIService-BPush"
  s.version           = "1.4.4"
  s.summary           = "Baidu push SDK. http://push.baidu.com"
  s.homepage          = "https://github.com/ElfSundae/AppComponents/tree/master/APIService/APIService-BPush.podspec"
  s.social_media_url  = "https://twitter.com/ElfSundae"
  s.authors           = { "Baidu" => "http://push.baidu.com" }
  s.license           = { :type => "Copyright", :text => "Copyright http://push.baidu.com" }
  s.source            = { :http => "http://boscdn.bpc.baidu.com/channelpush/BPush-SDK-iOS-1.4.4.zip" }
  s.platform          = :ios
  s.ios.deployment_target = "6.0"
  s.frameworks        = "SystemConfiguration", "CoreTelephony"
  s.libraries         = "z"
  s.default_subspec   = "IDFA"

  s.subspec "IDFA" do |ss|
    ss.frameworks             = "AdSupport"
    ss.source_files           = "**/idfaversion/BPush.h"
    ss.vendored_libraries     = "**/idfaversion/libBPush.a"
  end

  s.subspec "None-IDFA" do |ss|
    ss.source_files           = "**/normalversion/BPush.h"
    ss.vendored_libraries     = "**/normalversion/libBPush.a"
  end

end
