//
//  ViewController.h
//  tccc-user-ios-example
//
//  Created by gavinwjwang on 2023/7/10.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnStartCall;

@property (weak, nonatomic) IBOutlet UIButton *btnSpeaker;
@property (weak, nonatomic) IBOutlet UIButton *btnMute;

@property (weak, nonatomic) IBOutlet UILabel *lblUserSig;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (assign) IBOutlet UIImageView *mainPreView;
@property (assign) IBOutlet UIImageView *remoteView;

@end

