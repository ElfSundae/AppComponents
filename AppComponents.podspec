Pod::Spec.new do |s|
  s.name              = "AppComponents"
  s.version           = "1.1.5"
  s.license           = "MIT"
  s.summary           = "Components for iOS development."
  s.homepage          = "https://github.com/ElfSundae/AppComponents"
  s.authors           = { "Elf Sundae" => "http://0x123.com" }
  s.source            = { :git => "https://github.com/ElfSundae/AppComponents.git", :tag => s.version, :submodules => true }
  s.social_media_url  = "https://twitter.com/ElfSundae"

  s.platform              = :ios, "7.0"
  s.requires_arc          = true
  s.source_files          = "AppComponents/AppComponents.h"

  s.subspec "Core" do |ss|
    ss.source_files         = "AppComponents/Core/**/*.{h,m}"
    ss.frameworks           = "AdSupport"
    ss.dependency           "ESFramework/Core"
    ss.dependency           "UICKeyChainStore"
  end

  s.subspec "Networking" do |ss|
    ss.source_files         = "AppComponents/Networking/**/*.{h,m}"
    ss.dependency           "ESFramework/Core"
    ss.dependency           "AFNetworking", "~> 3.0"
  end

  s.subspec "App" do |ss|
    ss.source_files         = "AppComponents/App/**/*.{h,m}"
    ss.dependency           "AppComponents/Core"
    ss.dependency           "MBProgressHUD"
    ss.dependency           "ElfSundae-JTSImageViewController"
    ss.resource             = "AppComponents/App/AppComponentsApp.bundle"
  end

  s.subspec "UIKit" do |ss|
    ss.source_files         = "AppComponents/UIKit/**/*.{h,m}"
    ss.private_header_files = "AppComponents/UIKit/**/*+Private.h"
    ss.dependency           "AppComponents/App"
    ss.dependency           "ESFramework/UIKit"
    ss.dependency           "SDWebImage"
    ss.dependency           "IconFontKit/FontAwesome"
    ss.dependency           "WebViewJavascriptBridge"
  end

  s.subspec "Auth" do |ss|
    ss.source_files         = "AppComponents/Auth/**/*.{h,m}"
    ss.dependency           "AppComponents/App"
    ss.dependency           "ESFramework/UIKit"
    ss.dependency           "IconFontKit/FontAwesome"
  end

end
