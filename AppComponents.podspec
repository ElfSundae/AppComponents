Pod::Spec.new do |s|
  s.name              = "AppComponents"
  s.version           = "1.0.2"
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

  s.subspec "View" do |ss|
    ss.source_files         = "AppComponents/View/**/*.{h,m}"
    ss.dependency           "AppComponents/Core"
    ss.dependency           "ESFramework/UIKit"
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
    ss.dependency           "FontAwesomeKit/FontAwesome"
    ss.dependency           "JTSImageViewController"
  end

  s.subspec "Auth" do |ss|
    ss.source_files         = "AppComponents/Auth/**/*.{h,m}"
    ss.private_header_files = "AppComponents/Auth/**/*+Private.h"
    ss.dependency           "AppComponents/App"
    ss.dependency           "AppComponents/VendorServices/MobSMS"
  end

  s.subspec "WebKit" do |ss|
    ss.source_files         = "AppComponents/WebKit/**/*.{h,m}"
    ss.private_header_files = "AppComponents/WebKit/**/*+Private.h"
    ss.dependency           "AppComponents/App"
    ss.dependency           "WebViewJavascriptBridge"
    ss.dependency           "ESFramework/App"
    ss.dependency           "ESFramework/UIKit"
    ss.dependency           "ESFramework/StoreKit"
  end

  s.subspec "VendorServices" do |ss|
    ss.source_files         = "AppComponents/VendorServices/*.{h,m}"

    ss.subspec "UmengAnalytics" do |sss|
      sss.source_files      = "AppComponents/VendorServices/UmengAnalytics/**/*.{h,m}"
      sss.dependency        "ESFramework/App"
      sss.dependency        "APIService-UmengAnalytics"
    end

    ss.subspec "TalkingDataAnalytics" do |sss|
      sss.source_files      = "AppComponents/VendorServices/TalkingDataAnalytics/**/*.{h,m}"
      sss.dependency        "ESFramework/App"
      sss.dependency        "APIService-TalkingData"
    end

    ss.subspec "XGPush" do |sss|
      sss.source_files      = "AppComponents/VendorServices/XGPush/**/*.{h,m}"
      sss.dependency        "ESFramework/App"
      sss.dependency        "QQ_XGPush"
    end

    ss.subspec "MobSMS" do |sss|
      sss.source_files      = "AppComponents/VendorServices/MobSMS/**/*.{h,m}"
      sss.dependency        "ESFramework/App"
      sss.dependency        "MOBFoundation_IDFA"
      sss.dependency        "SMSSDK"
    end
  end # VendorService

end
