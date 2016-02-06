
+ `ACAuthVerifyPhoneViewController` 将MobSMS分离出来，只处理UI部分，发送和校验验证码提供block让外部执行。
+ ~~在ApiClient中showProgressHUD，会影响外部的progressHUD。比如请求前显示菊花，请求完成后隐藏菊花。（ApiClient中显示菊花时先检查keyWindows上是否已经有菊花）~~