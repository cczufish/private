HiWiFi Koala
=======
## 说明

本项目使用`CocoaPods`管理第三方软件

`HiWiFiKoala.xcworkspace文件`和`Pods目录`未包含在SVN版本库中

刚刚 CheckOut 的版本库，需要在`项目目录`下执行`pod install`才能正常运行

<font color=red>注意:</font> 打开项目文件时，需要打开`.xcworkspace`扩展名的文件

## 安装CocoaPods

见 [CocoaPods](http://blog.devtang.com/blog/2014/05/25/use-cocoapod-to-manage-ios-lib-dependency/)

	$ sudo gem install cocoapods
	$ pod setup
	
## 更新CocoaPods

	$ sudo gem update cocoapods


## 安装项目库

在项目目录下执行：

	$ pod install
	
	
## 升级项目库

在项目目录下执行：

	$ pod update

