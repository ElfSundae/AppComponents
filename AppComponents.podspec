Pod::Spec.new do |s|
  s.name              = "AppComponents"
  s.version           = "1.0.1"
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
    ss.dependency           "UICKeyChainStore"
    ss.dependency           "AppComponents/Core"
  end

  s.subspec "View" do |ss|
    ss.source_files         = "AppComponents/View/**/*.{h,m}"
    ss.dependency           "ESFramework/UIKit"
    ss.dependency           "AppComponents/Core"
  end

  s.subspec "Ad" do |ss|
    ss.source_files         = "AppComponents/Ad/**/*.{h,m}"
    ss.dependency           "ESFramework/App"
    ss.dependency           "AppComponents/Core"
  end

  s.subspec "AppUpdater" do |ss|
    ss.source_files         = "AppComponents/AppUpdater/**/*.{h,m}"
    ss.dependency           "ESFramework/App"
    ss.dependency           "ESFramework/StoreKit"
    ss.dependency           "AppComponents/Core"
  end

  s.subspec "Networking" do |ss|
    ss.source_files         = "AppComponents/Networking/**/*.{h,m}"
    ss.dependency           "AFNetworking", "~> 3.0"
    ss.dependency           "AppComponents/Encryptor"
    ss.dependency           "AppComponents/App"
  end

  s.subspec "App" do |ss|
    ss.source_files         = "AppComponents/App/**/*.{h,m}"
    ss.dependency           "APIService-UmengAnalytics"
    ss.dependency           "APIService-TalkingData"
    ss.dependency           "ESFramework/App"
    ss.dependency           "MBProgressHUD"
    ss.dependency           "FontAwesomeKit/FontAwesome"
    ss.dependency           "AppComponents/Core"
  end

  s.subspec "Authentication" do |ss|
    ss.source_files         = "AppComponents/Authentication/**/*.{h,m}"
    ss.private_header_files = "AppComponents/Authentication/**/*+Private.h"
    ss.dependency           "AppComponents/App"
    ss.dependency           "MOBFoundation_IDFA"
    ss.dependency           "SMSSDK"
  end
end
