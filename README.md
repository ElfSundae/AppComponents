AppComponents
---

[![Build Status](https://travis-ci.org/ElfSundae/AppComponents.svg)](https://travis-ci.org/ElfSundae/AppComponents)
[![Pod Version](http://img.shields.io/cocoapods/v/AppComponents.svg)](http://cocoadocs.org/docsets/AppComponents)

<center>**Warning: Work In Process, use it at your own risk!**</center>

## Summary

**AppComponents** is a series of components for iOS development,
it is based on several awesome third parts libraries.

## Installation

```ruby
pod 'AppComponents', '~> 1.0'`
```

or just install subspecs:

```ruby
pod 'AppComponents/App'
pod 'AppComponents/VendorServices/UmengAnalytics'
```

```ruby
pod 'AppComponents', :subspecs => ['App', 'VendorServices/UmengAnalytics']
```

```ruby
pod 'AppComponents', :git => 'https://github.com/ElfSundae/AppComponents.git', :branch => 'develop'
```

## Architecture

+ `AppComponents/Core`
+ `AppComponents/Encryptor` encryption and decryption
+ `AppComponents/UDID` generates Unique Device Identifier via IDFA
+ `AppComponents/UIKit`
+ `AppComponents/Ad` shows a simple ad banner while app is reviewing, to use IDFA in app
+ `AppComponents/AppUpdater` check/alert/download app new version
+ `AppComponents/Networking` backed on AFNetworking
+ `AppComponents/App`
+ `AppComponents/Auth` user authentication
+ `AppComponents/WebKit` UIWebViewController
+ `AppComponents/VendorServices` third parts libraries or services
    + `AppComponents/VendorServices/UmengAnalytics` 友盟统计
    + `AppComponents/VendorServices/TalkingDataAnalytics` TalkingData统计
    + `AppComponents/VendorServices/MobSMS` mob.com的免费短信验证码服务
    + `AppComponents/VendorServices/XGPush` 腾讯信鸽推送服务
    + `AppComponents/VendorServices/ImageViewController` 单张图片的查看大图

## License

AppComponents is released under the MIT license. See [LICENSE](LICENSE) for details.

