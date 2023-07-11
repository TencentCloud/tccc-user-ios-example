
## API 概览
### 创建实例和事件回调
| API | 描述 |
|-----|-----|
| [getTCCCShareInstance](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#a5f9c01b6f320d73299a8794fd1b113c2) | 创建 ITCCCWorkstation 实例（单例模式） |
| [destroyTCCCShareInstance](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#a291fad1a867e90296c28921c814abb96) | 销毁 ITCCCWorkstation 实例（单例模式）  |
| [addCallback](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#aed44903d7d6bac8b95754071e6e03d92) | 添加 ITCCCWorkstation 事件回调 |
| [removeCallback](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#a129572ebab88dae9f4779df3da5c844a) | 移除 ITCCCWorkstation 事件回调 |

#### 创建实例和设置事件回调示例代码
```c++
#include "tccc/include/ITCCCWorkstation.h"
using namespace tccc;
// 创建实例和设置事件回调
ITCCCWorkstation* tcccSDK = getTCCCShareInstance();
// 设置回调，TCCCCallbackImpl 需要继承 ITCCCCallback
class TCCCCallbackImpl:public ITCCCCallback {
public:
    TCCCCallbackImpl() {}
    ~TCCCCallbackImpl() {}

    void onError(TCCCError errCode, const char* errMsg, void* extraInfo) {}
    
    void onWarning(TCCCCWarning warningCode, const char* warningMsg, void* extraInfo) {}

    void onNewSession(TCCCSessionInfo info) {}

    void onEnded(EndedReason reason, const char* reasonMessage, const char* sessionId) {}
    
};
TCCCCallbackImpl* tcccCallback = new TCCCCallbackImpl();
tcccSDK->addCallback(tcccCallback);
// 销毁实例
destroyTCCCShareInstance();
tcccSDK = nullptr;
```

### 呼叫相关接口函数
| API | 描述 |
|-----|-----|
| [startCall](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#a44131b3f2307f59e84e8dc2547284468) | 发起通话 |
| [terminate ](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#ad246edc074358e8db219f524240c2e0e) | 结束通话 |
| [sendDTMF](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#a759c3add9cca0c158d8b76ddaf158b53) | 发送 DTMF（双音多频信号）|
| [mute](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#a2dad8c4fa7358a119203920194cc1983) | 静音 |
| [unmute](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#a154949474d50c76412757cbc9fb57ea1) | 取消静音 |
#### 发起呼叫和结束呼叫示例代码
```c++
class TCCCCommonCallback : public ITXCallback {
private:
    NSString* mFunName;
public:
    TCCCCommonCallback(NSString* funName) {
        mFunName = funName;
    }
    ~TCCCCommonCallback() override {
        
    }
    void OnSuccess() override {
      // 成功
    }
    
    void OnError(TCCCError error_code, const char *error_message) override {
        std::string copyErrMsg = makeString(error_message);
      // 失败
    }
};
TCCCCommonCallback* startCallCallbackImpl = nullptr;
if (nullptr == startCallCallbackImpl) {
  startCallCallbackImpl = new TCCCCommonCallback(@"startCall");
}
TCCCStartCallParams callParams;
//呼叫的手机号
callParams.to = "";
// 发起外呼
tcccSDK->call(callParams, startCallCallbackImpl);
// 结束通话
tcccSDK->terminate();
```


### 音频设备接口函数
| API | 描述 |
|-----|-----|
| [enableAudioVolumeEvaluation](https://tccc.qcloud.com/assets/doc/user/javaApiV2/classcom_1_1tencent_1_1tccc_1_1_t_c_c_c_cloud.html#a5866b48256ee303f594779ca4c443d2b) | 启用音量大小提示 |
| [mute](https://tccc.qcloud.com/assets/doc/user/javaApiV2/classcom_1_1tencent_1_1tccc_1_1_t_c_c_c_cloud.html#ac03dba575826214db1ef67c0f754f4c3) | 静音 |
| [unmute](https://tccc.qcloud.com/assets/doc/user/javaApiV2/classcom_1_1tencent_1_1tccc_1_1_t_c_c_c_cloud.html#a7f261eb0cd53b276626da36694583e6a) | 取消静音 |
| [startLocalAudio](https://tccc.qcloud.com/assets/doc/user/javaApiV2/classcom_1_1tencent_1_1tccc_1_1_t_c_c_c_cloud.html#ab3148068d47300eac5bb31ad15696de0) | 开启本地音频的采集和发布 |
| [setAudioRoute](https://tccc.qcloud.com/assets/doc/user/javaApiV2/interfacecom_1_1tencent_1_1tccc_1_1_t_c_c_c_device_manager.html#a3fc968a31ed5130fb960d0b594b7ac9b) | 设置音频路由（仅适用于移动端） |


### 调试相关接口
| API | 描述 |
|-----|-----|
| [getSDKVersion](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#adce46ac2533271abbe5fd1c9e2b5b269) | 获取 SDK 版本信息 |
| [setLogLevel](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#adc38b8e5f7c7bbb52913133a09c660c3) | 设置 Log 输出级别 |
| [setConsoleEnabled](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#ac96dc3ba8d3ee4415cdbdc66cd604526) | 启用/禁用控制台日志打印 |
| [callExperimentalAPI](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_workstation.html#a5496b58b1c9c5300ae10414d4a7f9222) | 调用实验性接口 |

#### 获取SDK版本示例代码
```c++
// 获取SDK 版本号
tcccSDK->getSDKVersion();
```


### 错误和警告事件
| API | 描述 |
|-----|-----|
| [onError](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_callback.html#a91194f813d01fb57815d779098de8ed5) | 错误事件回调 |
| [onWarning](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_callback.html#a5262b33074879d9e833c29a97ee42c14) | 警告事件回调 |

#### 处理错误回调事件回调示例代码
```c++
// 设置回调，TCCCCallbackImpl 需要继承 ITCCCCallback
class TCCCCallbackImpl:public ITCCCCallback {
public:
    TCCCCallbackImpl() {}
    ~TCCCCallbackImpl() {}
    // 错误事件回调
    void onError(TCCCError errCode, const char* errMsg, void* extraInfo) {}
    // 警告事件回调
    void onWarning(TCCCCWarning warningCode, const char* warningMsg, void* extraInfo) {}
};
TCCCCallbackImpl* tcccCallback = new TCCCCallbackImpl();
tcccSDK->addCallback(tcccCallback);
```

### 呼叫相关事件回调
| API | 描述 |
|-----|-----|
| [onAccepted](https://tccc.qcloud.com/assets/doc/user/javaApiV2/classcom_1_1tencent_1_1tccc_1_1_t_c_c_c_cloud_listener.html#acced7a9ef75a95cf563a335a04c2e8b1) | 对方接听事件 |
| [onEnded](https://tccc.qcloud.com/assets/doc/user/javaApiV2/classcom_1_1tencent_1_1tccc_1_1_t_c_c_c_cloud_listener.html#af4fd61e9ea213ede2325e67571dd3af0) | 通话结束事件 |


### 音视和网络质量相关事件回调
| API | 描述 |
|-----|-----|
| [onNetworkQuality](https://tccc.qcloud.com/assets/doc/user/javaApiV2/classcom_1_1tencent_1_1tccc_1_1_t_c_c_c_cloud_listener.html#a7f6d647f01ae71bd9fcba258464a4e5d) | 网络质量的实时统计回调 |
| [onAudioVolume](https://tccc.qcloud.com/assets/doc/user/javaApiV2/classcom_1_1tencent_1_1tccc_1_1_t_c_c_c_cloud_listener.html#a71311b8e7e252ad48c1392f0cf3305c3) | 音量大小的反馈回调 |

### 与云端连接情况的事件回调
| API | 描述 |
|-----|-----|
| [onConnectionLost](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_callback.html#ad80d24863ae3906e96809d5caa26d392) | SDK 与云端的连接已经断开 |
| [onTryToReconnect](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_callback.html#abafd1254e57eda469ae04c7073227752) | SDK 正在尝试重新连接到云端 |
| [onConnectionRecovery](https://tccc.qcloud.com//assets/doc/Agent/CppAPI/classtccc_1_1_i_t_c_c_c_callback.html#a881626fcdb9468c7a00a7419f5e1dc40) | SDK 与云端的连接已经恢复 |

#### 与云端连接情况的事件回调示例代码

```c++
// 设置回调，TCCCCallbackImpl 需要继承 ITCCCCallback
class TCCCCallbackImpl:public ITCCCCallback {
public:
    TCCCCallbackImpl() {}
    ~TCCCCallbackImpl() {}
    // SDK 与云端的连接已经断开
    void onConnectionLost(TCCCServerType serverType) {}
    // SDK 正在尝试重新连接到云端
    void onTryToReconnect(TCCCServerType serverType) {}
    // SDK 与云端的连接已经恢复
    void onConnectionRecovery(TCCCServerType serverType) {}
};
TCCCCallbackImpl* tcccCallback = new TCCCCallbackImpl();
tcccSDK->addCallback(tcccCallback);
```


## API 错误码
### 基础错误码

| 符号 | 值 | 含义 |
|---|---|---|
|ERR_NONE|0|无错误|
|ERR_SIP_SUCCESS|200|成功|
|TCCC_SYSTEM_ERROR|-1002|TCCC 系统错误|
|ERR_HTTP_REQUEST_FAILURE|-10001|Http 请求失败，请检查网络连接情况|
|ERR_HTTP_TOKEN_ERROR|-10002|userSig登录票据不正确或者已过期或者userId不准确|
|ERR_NETWORK_CANNOT_RESET|-10004|正在通话中，禁止重置网络操作&发起外呼|
