//
//  ViewController.m
//  tccc-agent-ios-example
//
//  Created by gavinwjwang on 2023/5/17.
//

#import "ViewController.h"
#import "GenerateTestUserSig.h"
#include "tccc/include/ITCCCCloud.h"
#include <string>

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIButton *btnStartCall;

@property (weak, nonatomic) IBOutlet UIButton *btnSpeaker;
@property (weak, nonatomic) IBOutlet UIButton *btnMute;

@property (weak, nonatomic) IBOutlet UILabel *lblUserSig;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;



@end

@implementation ViewController

using namespace tccc;

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

ITCCCCloud* tcccSDK = nullptr;
TCCCCommonCallback* startCallCallbackImpl = nullptr;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTcccSDK];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    destroyTCCCShareInstance();
    tcccSDK = nullptr;
    if (nullptr != startCallCallbackImpl) {
        delete  startCallCallbackImpl;
        startCallCallbackImpl = nullptr;
    }
}

- (void)initTcccSDK {
    tcccSDK = getTCCCShareInstance();
    // tcccSDK->addCallback(tcccCallback);
    // 获取TCCC SDK版本号
    const char *  version = tcccSDK->getSDKVersion();
    self.lblVersion.text =  [NSString stringWithUTF8String:version];
    NSLog(@"tccc SDK version: %s",version);
}

- (IBAction)getTokenButtonTapped:(UIButton *)sender {
    // 获取token
    [GenerateTestUserToken genTestUserSig:@"testByIos" completion:^(NSString *token, NSError *error) {
        if (error) {
            NSLog(@"请求失败: %@", error.localizedDescription);
        } else {
            self.lblUserSig.text = token;
            NSLog(@"请求成功,token= %@", token);
        }
    }];
}

- (IBAction)btnStartCallTapped:(id)sender {
    if (nullptr == startCallCallbackImpl) {
        startCallCallbackImpl = new TCCCCommonCallback(@"startCall");
    }
    TCCCCallParams callParams;
    callParams.channelId = AUDIO_CHANNELID;
    callParams.userId ="testByIos";
    callParams.sdkAppId = SDKAppID;
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


@end
