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

@property (nonatomic, strong) UITextField *seatUserIdField;
@property (nonatomic, strong) UITextField *tokenField;
@property (nonatomic, strong) UIButton *getTokenButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *isLoginButton;
@property (nonatomic, strong) UIButton *logoutButton;

@property (nonatomic, strong) UIButton *startCallButton;
@property (nonatomic, strong) UIButton *hangupButton;
@property (nonatomic, strong) UIButton *speakerButton;
@property (nonatomic, strong) UIButton *muteButton;


@property (nonatomic, strong) UITextView *txtVersion;

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
    self.txtVersion.text =  [NSString stringWithUTF8String:version];
    NSLog(@"tccc SDK version: %s",version);
}

- (void)getTokenButtonTapped:(UIButton *)sender {
    self.getTokenButton.selected = true;
    // 获取token
    [GenerateTestUserToken genTestUserSig:USERID completion:^(NSString *token, NSError *error) {
        self.getTokenButton.selected = false;
        if (error) {
            NSLog(@"请求失败: %@", error.localizedDescription);
        } else {
            self.tokenField.text = token;
            NSLog(@"请求成功,token= %@", token);
        }
    }];
}


- (void)startCallButtonTapped:(UIButton *)sender {
    if (nullptr == startCallCallbackImpl) {
        startCallCallbackImpl = new TCCCCommonCallback(@"startCall");
    }
    TCCCCallParams callParams;
    callParams.channelId = [TO UTF8String];
    callParams.clientData = "\n{xxx:\r\nxxxx\n}中国01 xxx02*-`";
    callParams.userId ="testByIos";
    callParams.sdkAppId = 10;
    callParams.userSig = "";
    tcccSDK->startCall(callParams, startCallCallbackImpl);
}

- (void)muteButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.muteButton setTitle:@"静音" forState:UIControlStateNormal];
}

- (void)hangupButtonTapped:(UIButton *)sender {
    // 终止会话
    tcccSDK->terminate();
}

- (void)speakerButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.speakerButton setTitle:@"扬声器" forState:UIControlStateNormal];
    
}


@end
