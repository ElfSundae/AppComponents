Pod::Spec.new do |s|
  s.name              = "APIService-UmengAnalytics"
  s.version           = "3.6.6.2"
  s.summary           = "Umeng Analytics SDK."
  s.homepage          = "https://github.com/ElfSundae/AppComponents/tree/master/APIService/APIService-UmengAnalytics.podspec"
  s.social_media_url  = "https://twitter.com/ElfSundae"
  s.authors           = { "Umeng" => "http://www.umeng.com" }
  s.license           = { :type => "Copyright", :text => "Copyright http://www.umeng.com" }
  s.source            = { :http => "http://dev.umeng.com/system/resources/W1siZiIsIjIwMTUvMTEvMjQvMTNfNTZfMDhfMzIyX3Vtc2RrX0lPU19hbmFseXRpY3NfaWRmYV92My42LjYuemlwIl1d/umsdk_IOS_analytics_idfa_v3.6.6.zip" }
  s.platform          = :ios
  s.ios.deployment_target = "6.0"
  s.frameworks        = "Security", "SystemConfiguration", "CoreTelephony", "CoreMotion", "AdSupport"
  s.libraries         = "z"
  s.source_files      = "**/MobClick.h", "**/MobClickSocialAnalytics.h"
  s.vendored_libraries = "**/libMobClickLibrary.a"
end
