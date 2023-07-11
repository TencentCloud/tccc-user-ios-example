## 快速跑通腾讯云呼叫中心用户端 ios Demo

腾讯云呼叫中心提供了 ios SDK，可以让座席实现拨打电话、手机等功能。也可以通过我们提供的 SDK 来实现在手机端、PC 端外呼、呼入来电接听等场景。
本文主要介绍如何快速跑通腾讯云呼叫中心 ios Demo，只要按照如下步骤进行配置，就可以跑通基于腾讯云呼叫中心相关功能。

## 开发环境要求

- Xcode 9.0+。 
- iOS 9.0 以上的 iPhone 或者 iPad 真机。
- 项目已配置有效的开发者签名。

## 前提条件

- 您已 [注册腾讯云](https://cloud.tencent.com/document/product/378/17985) 账号，并完成 [实名认证](https://cloud.tencent.com/document/product/378/3629) 。
- 您已 [开通云呼叫中心](https://cloud.tencent.com/document/product/679/48028#.E6.AD.A5.E9.AA.A41.EF.BC.9A.E5.87.86.E5.A4.87.E5.B7.A5.E4.BD.9C) 服务，并创建了 [云呼叫中心实例](https://cloud.tencent.com/document/product/679/48028#.E6.AD.A5.E9.AA.A42.EF.BC.9A.E5.88.9B.E5.BB.BA.E4.BA.91.E5.91.BC.E5.8F.AB.E4.B8.AD.E5.BF.83.E5.AE.9E.E4.BE.8B) 。


## 操作步骤
[](id:step1)
### 步骤1：配置音频客服
1. 登录 [呼叫中心管理端](https://tccc.qcloud.com/login)，选择**登录的呼叫中心** > **管理端** > **音频客服** > **技能组管理** > **添加技能组** 。

![](https://qcloudimg.tencent-cloud.cn/image/document/fae6c3b42347a16a06f0dda49dfc0f48.png)

2. 添加 **新客服** 到对应的技能组中。

![](https://qcloudimg.tencent-cloud.cn/image/document/09f724109a6e89aa5d645725d8fa7440.png)

3. 新增 IVR， **登录的呼叫中心** > **管理端** > **音频客服** > **IVR管理** > **呼入IVR** > **新建**。

![](https://qcloudimg.tencent-cloud.cn/image/document/ac2d7643f2be4c01d9cd8de03a981db4.png)

4. 新建 IVR，在 IVR 画布左上角输入 IVR 名称，如：音频客服 IVR。根据您的场景需要拖拽 IVR 模块到画布区域合适的位置释放，连接模块并在各个模块填写相应信息。IVR 流程必须以开始模块为第一个模块，以结束模块为最后一个模块。

![](https://qcloudimg.tencent-cloud.cn/image/document/d05ee5a7c6d0cbaa8f747f48f1d92597.png)

5. 新增配置音频入口。 选择**管理端** > **渠道管理** > **配置音频入口** > **新增 **，输入音频入口名称，

![](https://qcloudimg.tencent-cloud.cn/image/document/fd65a7d5f1e2ce995ab908c28f70a761.png)

6. 复制音频入口 ID。

![](https://qcloudimg.tencent-cloud.cn/image/document/e69f60d860d3e98da2d827e19766d0b5.png)

[](id:step2)
### 步骤1：下载 tccc-user-ios-example 源码
  根据实际业务需求 [tccc-user-ios-example](https://github.com/TencentCloud/tccc-user-ios-example) 源码。

[](id:step2)
### 步骤2：配置 tccc-user-ios-example 工程文件
1. 找到并打开 debug/GenerateTestUserToken.h 文件。

2. 设置 GenerateTestUserToken.h 文件中的相关参数：
<ul>
  <li/>USERID：座席账号，格式为 ： xxx@qq.com
  <li/>SDKAPPID：腾讯云呼叫中心 SDKAppId，需要替换为您自己账号下的 SDKAppId
	<li/>SECRETID：计算签名用的加密密钥ID。
  <li/>SECRETKEY：计算签名用的加密密钥Key。
</ul>

![](https://qcloudimg.tencent-cloud.cn/raw/d1e4b21ab990b257df19ae78e4bc64c8.png)

>!
>- 本文提到的生成 UserSig 的方案是在客户端代码中配置 SECRETID、SECRETKEY，该方法中 SECRETID、SECRETKEY 很容易被反编译逆向破解，一旦您的密钥泄露，攻击者就可以盗用您的腾讯云流量，因此**该方法仅适合本地跑通 tccc-user-android-example 和功能调试**。
>- 正确的 UserSig 签发方式是将 UserSig 的计算代码集成到您的服务端，并提供面向 App 的接口，在需要 UserSig 时由您的 App 向业务服务器发起请求获取动态 UserSig。更多详情请参见 [创建用户数据签名](https://cloud.tencent.com/document/product/679/58260)。


### 步骤3：编译运行
  使用 Xcode 打开源码工程 `tccc-user-ios-example`，单击**运行**即可。

1. 点击 **获取token** > **登录**，
2. 登录成功后点击外呼即可完成拨打功能。


### 运行效果

基本功能如下图所示

![](https://qcloudimg.tencent-cloud.cn/raw/38aa87531f0fdf95fe47c6ad76ea9bd1.png)


