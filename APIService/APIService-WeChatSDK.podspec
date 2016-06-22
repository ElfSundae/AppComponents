Pod::Spec.new do |s|
  s.name              = "APIService-WeChatSDK"
  s.version           = "1.7.1"
  s.summary           = "Wechat SDK. https://open.weixin.qq.com"
  s.homepage          = "https://github.com/ElfSundae/AppComponents"
  s.documentation_url = "https://open.weixin.qq.com"
  s.authors           = {
    "Tencent" => "http://open.weixin.qq.com"
  }
  s.license           = {
    :type => "Copyright",
    :text => "Copyright http://open.weixin.qq.com"
  }
  s.source            = {
    :http => "https://res.wx.qq.com/open/zh_CN/htmledition/res/dev/download/sdk/WeChatSDK1.7.1.zip"
  }
  s.platform          = :ios, "6.0"
  s.frameworks        = "SystemConfiguration", "CoreTelephony"
  s.libraries         = "z", "sqlite3", "c++"

  s.source_files      = "**/WXApi.h", "**/WXApiObject.h", "**/WechatAuthSDK.h"
  s.vendored_libraries = "**/libWeChatSDK.a"
end
