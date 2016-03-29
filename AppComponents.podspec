Pod::Spec.new do |s|
  s.name              = "AppComponents"
  s.version           = "1.0.7"
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
    ss.frameworks           = "AdSupport"
    ss.dependency           "ESFramework/Core"
    ss.dependency           "UICKeyChainStore"
  end

  s.subspec "App" do |ss|
    ss.source_files         = "AppComponents/App/**/*.{h,m}"
    ss.dependency           "AppComponents/Core"
    ss.dependency           "MBProgressHUD"
    ss.resource             = "AppComponents/App/AppComponentsApp.bundle"
  end

  s.subspec "Networking" do |ss|
    ss.source_files         = "AppComponents/Networking/**/*.{h,m}"
    ss.dependency           "AFNetworking", "~> 3.0"
    ss.dependency           "AppComponents/App"
  end

  s.subspec "UIKit" do |ss|
    ss.source_files         = "AppComponents/UIKit/**/*.{h,m}"
    ss.private_header_files = "AppComponents/UIKit/**/*+Private.h"
    ss.dependency           "AppComponents/App"
    ss.dependency           "ESFramework/UIKit"
    ss.dependency           "SDWebImage"
    ss.dependency           "IconFontsKit/FontAwesome"
    ss.dependency           "WebViewJavascriptBridge"
  end

  s.subspec "Auth" do |ss|
    ss.source_files         = "AppComponents/Auth/**/*.{h,m}"
    ss.dependency           "AppComponents/App"
    ss.dependency           "AppComponents/VendorServices/MobSMS"
    ss.dependency           "ESFramework/UIKit"
    ss.dependency           "IconFontsKit/FontAwesome"
  end

  s.subspec "VendorServices" do |ss|
    ss.source_files         = "AppComponents/VendorServices/*.{h,m}"

    ss.subspec "UmengAnalytics" do |sss|
      sss.source_files      = "AppComponents/VendorServices/UmengAnalytics/**/*.{h,m}"
      sss.dependency        "APIService-UmengAnalytics"
      sss.dependency        "ESFramework/Core"
    end

    ss.subspec "TalkingDataAnalytics" do |sss|
      sss.source_files      = "AppComponents/VendorServices/TalkingDataAnalytics/**/*.{h,m}"
      sss.dependency        "APIService-TalkingData"
      sss.dependency        "ESFramework/Core"
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
      sss.dependency        "ESFramework/Core"
    end

    ss.subspec "ImageViewController" do |sss|
      sss.source_files      = "AppComponents/VendorServices/ImageViewController/**/*.{h,m}"
      sss.dependency        "JTSImageViewController"
      sss.dependency        "AppComponents/App"
    end
  end # VendorServices
end
