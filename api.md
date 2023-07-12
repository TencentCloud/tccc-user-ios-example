
## API 概览
### 创建实例和事件回调
| API | 描述 |
|-----|-----|
| [getTCCCShareInstance]() | 创建 ITCCCWorkstation 实例（单例模式） |
| [destroyTCCCShareInstance]() | 销毁 ITCCCWorkstation 实例（单例模式）  |
| [addCallback]() | 添加 ITCCCWorkstation 事件回调 |
| [removeCallback]() | 移除 ITCCCWorkstation 事件回调 |

#### 创建实例和设置事件回调示例代码
```c++
#include "tccc/include/ITCCCCloud.h"
using namespace tccc;
// 创建实例和设置事件回调
ITCCCCloud* tcccSDK = getTCCCShareInstance();
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
| [startCall]() | 发起通话 |
| [terminate ]() | 结束通话 |
| [sendDTMF]() | 发送 DTMF（双音多频信号）|
| [mute]() | 静音 |
| [unmute]() | 取消静音 |
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
| [enableAudioVolumeEvaluation]() | 启用音量大小提示 |
| [mute]() | 静音 |
| [unmute]() | 取消静音 |
| [startLocalAudio]() | 开启本地音频的采集和发布 |
| [setAudioRoute]() | 设置音频路由（仅适用于移动端） |


### 调试相关接口
| API | 描述 |
|-----|-----|
| [getSDKVersion]() | 获取 SDK 版本信息 |
| [setLogLevel]() | 设置 Log 输出级别 |
| [setConsoleEnabled]() | 启用/禁用控制台日志打印 |
| [callExperimentalAPI]() | 调用实验性接口 |

#### 获取SDK版本示例代码
```c++
// 获取SDK 版本号
tcccSDK->getSDKVersion();
```


### 错误和警告事件
| API | 描述 |
|-----|-----|
| [onError]() | 错误事件回调 |
| [onWarning]() | 警告事件回调 |

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
| [onAccepted]() | 对方接听事件 |
| [onEnded]() | 通话结束事件 |


### 音视和网络质量相关事件回调
| API | 描述 |
|-----|-----|
| [onNetworkQuality]() | 网络质量的实时统计回调 |
| [onAudioVolume]() | 音量大小的反馈回调 |

### 与云端连接情况的事件回调
| API | 描述 |
|-----|-----|
| [onConnectionLost]() | SDK 与云端的连接已经断开 |
| [onTryToReconnect]() | SDK 正在尝试重新连接到云端 |
| [onConnectionRecovery]() | SDK 与云端的连接已经恢复 |

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
