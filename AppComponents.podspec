Pod::Spec.new do |s|
  s.name              = "AppComponents"
  s.version           = "1.0.0"
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
    ss.dependency           "UICKeyChainStore", "~> 2.0"
  end

end
