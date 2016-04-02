Pod::Spec.new do |s|
  s.name              = "APIService-WeChatSDK"
  s.version           = "1.6.2.1"
  s.summary           = "Wechat SDK"
  s.homepage          = "https://github.com/ElfSundae/AppComponents/tree/master/APIService/APIService-WeChatSDK.podspec"
  s.social_media_url  = "https://twitter.com/ElfSundae"
  s.authors           = { "Tencent" => "http://open.weixin.qq.com" }
  s.license           = { :type => "Copyright", :text => "Copyright http://open.weixin.qq.com" }
  s.source            = { :http => "https://res.wx.qq.com/open/zh_CN/htmledition/res/dev/download/sdk/WeChatSDK1.6.2.zip" }
  s.platform          = :ios
  s.ios.deployment_target = "6.0"
  s.frameworks        = "SystemConfiguration", "CoreTelephony"
  s.libraries         = "z", "sqlite3", "c++"
  s.source_files      = "**/WXApi.h", "**/WXApiObject.h", "**/WechatAuthSDK.h"
  s.vendored_libraries = "**/libWeChatSDK.a"
end
