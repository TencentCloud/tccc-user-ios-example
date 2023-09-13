# 快速集成腾讯云联络中心 ios User SDK
    本文主要介绍如何快速地将腾讯云联络中心 ios User SDK 集成到您的项目中，只要按照如下步骤进行配置，就可以完成 SDK 的集成工作。

## 开发环境要求

- Xcode 9.0+。 
- iOS 9.0 以上的 iPhone 或者 iPad 真机。
- 项目已配置有效的开发者签名。


## 集成 SDK

### 手动下载

目前我们暂时还未发布到 CocoaPods ，您只能手动下载 SDK 集成到工程里。

1. 下载最新版本 [TCCC User SDK](https://tccc.qcloud.com/assets/doc/user/release/TCCCCloud_ios_last.zip)。

2. 打开您的 Xcode 工程项目，选择要运行的 target , 选中 **Build Phases** 项。

![](https://qcloudimg.tencent-cloud.cn/raw/0a5523692af9644c5c5b641b85d2deeb.png)

3. 单击 Link Binary with Libraries 项展开，单击底下的“+”号图标去添加依赖库。

![](https://qcloudimg.tencent-cloud.cn/raw/84d1a47fdeab5f1fd50080adf9150ff8.png)

4. 依次添加下载的 **TCCCCloud.Framework**、**TXFFmpeg.xcframework**、**TXSoundTouch.xcframework**、及其所需依赖库 **GLKit.framework**、**AssetsLibrary.framework**、**SystemConfiguration.framework**、**libsqlite3.0.tbd**、**CoreTelephony.framework**、**AVFoundation.framework**、**OpenGLES.framework**、**Accelerate.framework**、**MetalKit.framework**、**libresolv.tbd**、**MobileCoreServices.framework**、**libc++.tbd**、**CoreMedia.framework**。

![](https://qcloudimg.tencent-cloud.cn/raw/d567de470f17a519565aa451e17d7af2.png)

5. 单击 General，选择 **Frameworks,Libraries,and Embedded Content**，检查 **TCCCCloud.framework** 所需要动态库 **TXFFmpeg.xcframework**、**TXSoundTouch.xcframework**是否已经添加，是否正确选择选择 Embed & Sign，如果没有单击底下的“**+**”号图标依次添加。

![](https://qcloudimg.tencent-cloud.cn/raw/521b3963352e92d7d976319779ff896e.png)

6. 在工程target中Build Settings的**Other Linker Flags**增加 **-ObjC** 配置。

![](https://qcloudimg.tencent-cloud.cn/raw/c7a890a392a0f1cd667d2bea2c4d46aa.png)

7. 配置 **Header Search Paths**。如下类似输入 **$(PROJECT_DIR)/tccc-User-ios-example/framework/TCCCCloud.framework/Headers**

![](https://qcloudimg.tencent-cloud.cn/raw/63f09f767799ab6f11c8f74145c8c820.png)


## 配置 App 权限
1. 如需使用 SDK 提供的音视频功能，需要给 App 授权麦克风的使用权限。在 App 的 Info.plist 中添加以下两项，分别对应麦克风在系统弹出授权对话框时的提示信息。

  ![](https://qcloudimg.tencent-cloud.cn/raw/c92aa8cc4dcfff1e8a42e85a5becaef9.png)

  - Privacy - Microphone Usage Description，并填入麦克风使用目的提示语。


2. 如需 App 进入后台仍然运行相关功能，可在 XCode 中选中当前工程项目，并在 Capabilities 下将设置项  Background Modes 设定为 ON，并勾选 Audio，AirPlay and Picture in Picture ，如下图所示：

![](https://qcloudimg.tencent-cloud.cn/raw/30d6ae52e0d31a9fbd07ba393a9070c1.png)


## 代码实现

目前我们只提供了通过 C++ 接口，可以用下面代码引入头文件

```c++
// 引入C++头文件
#include "tccc/include/ITCCCCloud.h"
// 使用tccc命名空间
using namespace tccc;
// 获取tcccSDK 单例
ITCCCCloud* tcccSDK = getTCCCShareInstance();
// 获取SDK版本号
const char *  version = tcccSDK->getSDKVersion();

```

具体编码实现可参考 [API 概览以及示例](api.md)

## 常见问题

###  如何查看 TCCC 日志？

TCCC 的日志默认压缩加密，后缀为 .log。
- ios：
	- 日志路径：**sandbox/Documents/tccc** 

### 在ios下回调是否都在主线程
目前在ios下回调都不在主线程，需要业务层面上判断并且把他转为主线线程
```oc
if ([NSThread isMainThread]) {
    // 在主线程，直接可以处理
    return;
}
dispatch_async(dispatch_get_main_queue(), ^{
    // 回调在非主线程。
});
```

### TCCC 怎么校验生成的 UserSig 是否正确？
 
 可通过云 API 调用生成UserSig，具体可查看 [创建用户数据签名](https://cloud.tencent.com/document/product/679/58260) 接口文档



