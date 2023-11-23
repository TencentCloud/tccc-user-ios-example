//
//  ViewController.m
//  tccc-agent-ios-example
//
//  Created by gavinwjwang on 2023/5/17.
//

#import "ViewController.h"
#import "GenerateTestUserSig.h"
#include "TCCCCloud/tccc/include/ITCCCCloud.h"
#include <string>

@interface ViewController ()


@end

@implementation ViewController

using namespace tccc;

ITCCCCloud* tcccSDK = nullptr;

class TCCCCommonCallback : public ITXCallback {
private:
    NSString* mFunName;
    inline std::string makeString(const char* str) {
        return (nullptr == str ? "" : std::string(str));
    }
public:
    TCCCCommonCallback(NSString* funName) {
        mFunName = funName;
    }
    ~TCCCCommonCallback() override {
        
    }
    void OnSuccess() override {
        if ([NSThread isMainThread]) {
            NSLog(@"<== %@ OnSuccess",mFunName);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"<== %@ OnSuccess",mFunName);
            });
        }
    }
    
    void OnError(TCCCError error_code, const char *error_message) override {
        std::string copyErrMsg = makeString(error_message);
        if ([NSThread isMainThread]) {
            NSLog(@"<== %@ OnError errCode: %d , errMsg: %s",mFunName,error_code,copyErrMsg.c_str());
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"<== %@ onError errCode: %d , errMsg: %s",mFunName,error_code,copyErrMsg.c_str());
            });
        }
    }
};

class TestTCCCCallbackImpl:public ITCCCCallback
{
private:
    ViewController* mViewController;
    inline std::string makeString(const char* str) {
        return (nullptr == str ? "" : std::string(str));
    }
public:
    TestTCCCCallbackImpl(ViewController* controller) {
        mViewController = controller;
    }
    ~TestTCCCCallbackImpl() {}
    void onError(TCCCError errCode, const char* errMsg, void* extraInfo) {
        std::string copyErrMsg = makeString(errMsg);
        if ([NSThread isMainThread]) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    
    void onWarning(TCCCCWarning warningCode, const char* warningMsg, void* extraInfo) {
        std::string copyWarningMsg = makeString(warningMsg);
        if ([NSThread isMainThread]) {
            
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    
    void onEnded(EndedReason reason, const char* reasonMessage, const char* sessionId) {
        std::string copyReasonMessage = makeString(reasonMessage);
        std::string copySessionID = makeString(sessionId);
        if ([NSThread isMainThread]) {
            
            return;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
    }
    
    void onAccepted(const char* sessionId) {
        std::string copySessionID = makeString(sessionId);
        if ([NSThread isMainThread]) {
            
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    };
    
    void onUserVideoAvailable(const char* userId, bool available) {
        if (available) {
            id remoteViewPtr = [mViewController remoteView];
            void *cppRemoteViewPtr = (__bridge void *)(remoteViewPtr);
            tcccSDK->startRemoteView(userId,TCCCVideoStreamType::TCCCVideoStreamTypeBig,cppRemoteViewPtr);
        } else {
            tcccSDK->stopRemoteView(userId, TCCCVideoStreamType::TCCCVideoStreamTypeBig);
        }
    }
    
    void onAudioVolume(TCCCVolumeInfo* volumeInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    
    void onNetworkQuality(TCCCQualityInfo localQuality, TCCCQualityInfo* remoteQuality,
                          uint32_t remoteQualityCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
private:
    
};


TCCCCommonCallback* startCallCallbackImpl = nullptr;
TestTCCCCallbackImpl* tcccCallbackImpl = nullptr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTcccSDK];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    tcccSDK->removeCallback(tcccCallbackImpl);
    delete tcccCallbackImpl;
    destroyTCCCShareInstance();
    tcccSDK = nullptr;
    if (nullptr != startCallCallbackImpl) {
        delete  startCallCallbackImpl;
        startCallCallbackImpl = nullptr;
    }
}

- (void)initTcccSDK {
    tcccSDK = getTCCCShareInstance();
    tcccCallbackImpl = new TestTCCCCallbackImpl(self);
    tcccSDK->addCallback(tcccCallbackImpl);
    // 获取TCCC SDK版本号
    const char *  version = tcccSDK->getSDKVersion();
    self.lblVersion.text =  [NSString stringWithUTF8String:version];
    NSLog(@"tccc SDK version: %s",version);
}

- (IBAction)getTokenButtonTapped:(UIButton *)sender {
    // 获取token
    [GenerateTestUserToken genTestUserSig:@"testByIos" completion:^(NSString *userSig, NSError *error) {
        if (error) {
            NSLog(@"请求失败: %@", error.localizedDescription);
        } else {
            self.lblUserSig.text = userSig;
            NSLog(@"请求成功,token= %@", userSig);
        }
    }];
}

- (IBAction)btnStartVoipCallTapped:(id)sender {
    if (nullptr == startCallCallbackImpl) {
        startCallCallbackImpl = new TCCCCommonCallback(@"startCall");
    }
    TCCCCallParams callParams;
    callParams.channelId = AUDIO_CHANNELID;
    callParams.userId ="testByIos";
    callParams.sdkAppId = SDKAppID;
    // 指定为音频客服
    callParams.callType = TCCCCallType::Voip;
    NSString * userSig = self.lblUserSig.text;
    callParams.userSig = [userSig UTF8String];
    tcccSDK->startCall(callParams, startCallCallbackImpl);
}
- (IBAction)btnStartVideoClick:(id)sender {
    if (nullptr == startCallCallbackImpl) {
        startCallCallbackImpl = new TCCCCommonCallback(@"startCall");
    }
    TCCCCallParams callParams;
    callParams.channelId = VIDEO_CHANNELID;
    callParams.userId ="testByIos";
    callParams.sdkAppId = SDKAppID;
    // 指定为视频客服
    callParams.callType = TCCCCallType::Video;
    NSString * userSig = self.lblUserSig.text;
    callParams.userSig = [userSig UTF8String];
    tcccSDK->startCall(callParams, startCallCallbackImpl);
}


- (IBAction)muteButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected) {
        [self.btnMute setTitle:@"取消静音" forState:UIControlStateNormal];
    } else {
        [self.btnMute setTitle:@"静  音" forState:UIControlStateNormal];
    }
    
}

- (IBAction)hangupButtonTapped:(UIButton *)sender {
    // 终止会话
    tcccSDK->terminate();
}

- (IBAction)speakerButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected) {
        [self.btnSpeaker setTitle:@"耳麦" forState:UIControlStateNormal];
    } else {
        [self.btnSpeaker setTitle:@"扬声器" forState:UIControlStateNormal];
    }
}

- (IBAction)btnStartPreviewClick:(id)sender {
    id mainViewPtr = [self mainPreView];
    void *cppMainViewPtr = (__bridge void *)(mainViewPtr);
    tcccSDK->startLocalPreview(true,cppMainViewPtr);
}

- (IBAction)btnStopPreviewClick:(id)sender {
    tcccSDK->stopLocalPreview();
}

@end
