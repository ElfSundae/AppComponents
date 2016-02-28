Pod::Spec.new do |s|
  s.name              = "AppComponents"
  s.version           = "1.0.6"
  s.license           = "MIT"
  s.summary           = "Components for iOS development."
  s.homepage          = "https://github.com/ElfSundae/AppComponents"
  s.authors           = { "Elf Sundae" => "http://0x123.com" }
  s.source            = { :git => "https://github.com/ElfSundae/AppComponents.git", :tag => s.version, :submodules => true }
  s.social_media_url  = "https://twitter.com/ElfSundae"

  s.platform              = :ios
  s.ios.deployment_target = "7.0"
  s.requires_arc          = true
  s.source_files          = "AppComponents/AppComponents.h"

  s.subspec "Core" do |ss|
    ss.source_files         = "AppComponents/Core/**/*.{h,m}"
    ss.private_header_files = "AppComponents/Core/**/*+Private.h"
    ss.dependency           "ESFramework/Core"
    ss.dependency           "ESFramework/Additions"
  end

  s.subspec "Encryptor" do |ss|
    ss.source_files         = "AppComponents/Encryptor/**/*.{h,m}"
    ss.dependency           "ESFramework/Core"
  end

  s.subspec "UDID" do |ss|
    ss.source_files         = "AppComponents/UDID/**/*.{h,m}"
    ss.frameworks           = "AdSupport"
    ss.dependency           "AppComponents/Core"
    ss.dependency           "UICKeyChainStore"
  end

  s.subspec "Ad" do |ss|
    ss.source_files         = "AppComponents/Ad/**/*.{h,m}"
    ss.dependency           "AppComponents/Core"
    ss.dependency           "ESFramework/App"
  end

  s.subspec "AppUpdater" do |ss|
    ss.source_files         = "AppComponents/AppUpdater/**/*.{h,m}"
    ss.dependency           "AppComponents/Core"
    ss.dependency           "ESFramework/App"
    ss.dependency           "ESFramework/StoreKit"
  end

  s.subspec "Networking" do |ss|
    ss.source_files         = "AppComponents/Networking/**/*.{h,m}"
    ss.dependency           "AFNetworking", "~> 3.0"
    ss.dependency           "AppComponents/App"
    ss.dependency           "AppComponents/Encryptor"
  end

  s.subspec "App" do |ss|
    ss.source_files         = "AppComponents/App/**/*.{h,m}"
    ss.dependency           "AppComponents/Core"
    ss.dependency           "ESFramework/App"
    ss.dependency           "MBProgressHUD"
    ss.resource             = "AppComponents/App/Resources/*.png"
  end

  s.subspec "UIKit" do |ss|
    ss.source_files         = "AppComponents/UIKit/**/*.{h,m}"
    ss.dependency           "AppComponents/App"
    ss.dependency           "IconFontsKit/FontAwesome"
    ss.dependency           "ESFramework/UIKit"
    ss.dependency           "SDWebImage/Core"
  end

  s.subspec "Auth" do |ss|
    ss.source_files         = "AppComponents/Auth/**/*.{h,m}"
    ss.private_header_files = "AppComponents/Auth/**/*+Private.h"
    ss.dependency           "AppComponents/App"
    ss.dependency           "AppComponents/VendorServices/MobSMS"
    ss.dependency           "ESFramework/UIKit/View"
    ss.dependency           "IconFontsKit/FontAwesome"
  end

  s.subspec "WebKit" do |ss|
    ss.source_files         = "AppComponents/WebKit/**/*.{h,m}"
    ss.dependency           "AppComponents/App"
    ss.dependency           "AppComponents/VendorServices/ImageViewController"
    ss.dependency           "AppComponents/VendorServices/WebViewJavascriptBridge"
    ss.dependency           "ESFramework/UIKit/View"
    ss.dependency           "ESFramework/UIKit/RefreshControl"
    ss.dependency           "ESFramework/StoreKit"
  end

  s.subspec "VendorServices" do |ss|
    ss.source_files         = "AppComponents/VendorServices/*.{h,m}"

    ss.subspec "UmengAnalytics" do |sss|
      sss.source_files      = "AppComponents/VendorServices/UmengAnalytics/**/*.{h,m}"
      sss.dependency        "APIService-UmengAnalytics"
      sss.dependency        "ESFramework/App"
    end

    ss.subspec "TalkingDataAnalytics" do |sss|
      sss.source_files      = "AppComponents/VendorServices/TalkingDataAnalytics/**/*.{h,m}"
      sss.dependency        "APIService-TalkingData"
      sss.dependency        "ESFramework/App"
    end

    ss.subspec "XGPush" do |sss|
      sss.source_files      = "AppComponents/VendorServices/XGPush/**/*.{h,m}"
      sss.dependency        "APIService-XGPush"
      sss.dependency        "AppComponents/App"
    end

    ss.subspec "MobSMS" do |sss|
      sss.source_files      = "AppComponents/VendorServices/MobSMS/**/*.{h,m}"
      sss.dependency        "MOBFoundation_IDFA"
      sss.dependency        "SMSSDK"
      sss.dependency        "ESFramework/App"
    end

    ss.subspec "ImageViewController" do |sss|
      sss.source_files      = "AppComponents/VendorServices/ImageViewController/**/*.{h,m}"
      sss.dependency        "JTSImageViewController"
      sss.dependency        "AppComponents/App"
    end

    ss.subspec "WebViewJavascriptBridge" do |sss|
      sss.source_files      = "AppComponents/VendorServices/WebViewJavascriptBridge/**/*.{h,m}"
      sss.dependency        "WebViewJavascriptBridge", "~> 5.0"
      sss.dependency        "ESFramework/Core"
    end

  end # VendorServices

end
