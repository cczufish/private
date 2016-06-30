//
//  HWFSpeedTestViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-17.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//
//    弧度=角度乘以π后再除以180
//    角度=弧度除以π再乘以180

#import "HWFSpeedTestViewController.h"
#import "HWFService+Router.h"
#import "HWFCircleView.h"
#import "UIViewExt.h"
#import <pop/POP.h>


#define ANIMATION_DURATION 0.0

#define TIMER_DELAY 5

#define TOTAL_TIMEOUT_TIME 60
#define UP_TIMEOUT_TIME 30
#define DOWN_TIMEOUT_TIME 30

@interface HWFSpeedTestViewController () <POPAnimationDelegate>

#warning --------------接口失败超时的时候求平均值，2.一直running超时

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSString *actionId;

//指针
@property (weak, nonatomic) IBOutlet HWFCircleView *circleBgView;
@property (weak, nonatomic) IBOutlet UIImageView *nodeImgView;

//上传下载
@property (weak, nonatomic) IBOutlet UIImageView *downLoadImgView;
@property (weak, nonatomic) IBOutlet UILabel *downLoadTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLoadSpeed;
@property (weak, nonatomic) IBOutlet UIImageView *upLoadImgView;
@property (weak, nonatomic) IBOutlet UILabel *uploadTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadSpeed;

//按钮
@property (weak, nonatomic) IBOutlet UIButton *speedTestButton;
@property (assign,nonatomic) BOOL speedFlag;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

//测速结果
@property (strong, nonatomic) IBOutlet UIView *speedResultBgView;
@property (weak, nonatomic) IBOutlet UILabel *currentSpeedStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *speedResultImgView;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (strong, nonatomic) IBOutlet UIView *closeResultImgView;

//保存上下数据
@property (strong,nonatomic) NSMutableDictionary *upDictionary;
@property (strong,nonatomic) NSMutableDictionary *downDictionary;

//是否完成
@property (assign,nonatomic) BOOL isUpFinish;
@property (assign,nonatomic) BOOL isDownpFinish;

@property (assign,nonatomic) CGFloat lastSpeed;//上行的上一次速度

//颜色数组
@property (strong,nonatomic) NSMutableArray *colorArray;
//图片数组
@property (strong,nonatomic) NSMutableArray *downPictureArray;
@property (strong,nonatomic) NSMutableArray *uploadPictureArray;

//标识位
@property (assign,nonatomic) int count;//第一次上行动画结果
@property (strong,nonatomic) NSDate *date;//第一开始上行测速动画
@property (strong,nonatomic) NSDate *firstGetSpeedDate;//第一取测速结果时间
@property (assign,nonatomic) BOOL isStartDownAnimation;//是否要开始下行测速了


@end

@implementation HWFSpeedTestViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [self startTime];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self stopTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
    
    //指针初始位置
    self.nodeImgView.transform = CGAffineTransformMakeRotation(M_PI/180.0 * 62.0);
}

- (void)startTime {

    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_DELAY target:self selector:@selector(loadSpeedTestResult) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)recoverColorArray {
    if (self.colorArray.count > 0) {
        [self.colorArray removeAllObjects];
    }
    NSArray *array = @[COLOR_HEX(0x91c4e1),COLOR_HEX(0x91c4e1),COLOR_HEX(0x91c4e1),COLOR_HEX(0x91c4e1),COLOR_HEX(0x91c4e1),COLOR_HEX(0x2bc9e3),COLOR_HEX(0x2bc9e3),COLOR_HEX(0x1cbc8d)];
    self.colorArray = [[NSMutableArray alloc]initWithArray:array];
    self.circleBgView.acceptColorArr = self.colorArray;
    [self.circleBgView setNeedsDisplay];
}

- (void)initData {
    //初始值
    self.count = 0;
    self.lastSpeed = -1;
    
    self.upDictionary = [[NSMutableDictionary alloc]init];
    self.downDictionary = [[NSMutableDictionary alloc]init];
    
    [self recoverColorArray];
    
    self.downPictureArray = [[NSMutableArray alloc]init];
    for (int i=1; i<=5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"download-ico%d", i]];
        if (image) {
            [self.downPictureArray addObject:image];
        }
    }
    
    self.uploadPictureArray = [[NSMutableArray alloc]init];
    for (int i=1; i<=5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"upload-ico%d", i]];
        if (image) {
            [self.uploadPictureArray addObject:image];
        }
    }
}

- (void)initView {
    
    self.title = @"一键测速";
    [self addBackBarButtonItem];
    self.downLoadTipLabel.text = @"下载速度";
    self.downLoadSpeed.text = @"0KB/s";
    self.uploadTipLabel.text = @"上传速度";
    self.uploadSpeed.text = @"0KB/s";
    [self.speedTestButton setTitle:@"点击测速" forState:UIControlStateNormal];
    self.currentSpeedStatusLabel.textColor = COLOR_HEX(0x30b0f8);
    //?????
    self.nodeImgView.clipsToBounds = YES;
    
    self.tipLabel.text = @"测速结果仅供参考,实际带宽请咨询运营商";
    //320 × 320
    self.circleBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"panel-bg"]];
    //speedResult
    [self.view addSubview:self.speedResultBgView];
    self.speedResultBgView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *heightConstraint;
    NSLayoutConstraint *topConstraint;
    if (SCREEN_HEIGHT <= 568) {
        heightConstraint = [NSLayoutConstraint constraintWithItem: self.speedResultBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:240];
        topConstraint = [NSLayoutConstraint constraintWithItem: self.speedResultBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-240];
        topConstraint.identifier = @"speedResultTopCons";
    } else {
        heightConstraint = [NSLayoutConstraint constraintWithItem: self.speedResultBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:294];
        topConstraint = [NSLayoutConstraint constraintWithItem: self.speedResultBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-294];
        topConstraint.identifier = @"speedResultTopCons";
    }
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem: self.speedResultBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: self.speedResultBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[heightConstraint,topConstraint,leadingConstraint,trailingConstraint]];
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
    
    //为了适配，改约束
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeTop && constraint.relation == NSLayoutRelationEqual && constraint.secondAttribute == NSLayoutAttributeTop && constraint.constant == 294) {
            if (SCREEN_HEIGHT <= 568) {
                constraint.constant = 240;
            } else {
                constraint.constant = 294;
            }
        }
    }
    
}

#pragma mark - 告诉路由器开始测速
- (void)loadData {
    [self loadingViewShow];
    [[HWFService defaultService]doRouterSpeedTestWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            
            self.actionId = [data objectForKey:@"actid"];
            [self loadSpeedTestResult];
            [self startTime];
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - 获取测速结果
- (void) loadSpeedTestResult {

    if (!self.actionId || (self.actionId &&[self.actionId isEqualToString:@""])) {
        [self showTipWithType:HWFTipTypeFailure code:CODE_NIL message:@"测速失败"];
        return;
        
    } else {
        [[HWFService defaultService]loadRouterSpeedTestResultWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] actID:self.actionId completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            if (code == CODE_SUCCESS) {
                NSLog(@"===================%@",data);
                if (!self.isUpFinish) {
                    //上行没finish
                    if ([data objectForKey:@"dir"] && [data objectForKey:@"seq"] && [[data objectForKey:@"dir"] isEqualToString:@"up"]) {
                        if ([[data objectForKey:@"status"]isEqualToString:@"running"]) {
                            //执行指针动画
                            CGFloat speed =  [[data objectForKey:@"speed"]floatValue];
                            float currentAngle = [self getAngleWithSpeed:speed];
                            if (self.lastSpeed == -1) {
                                [self doAnimationfromAngle:62.0 toAngle:currentAngle withDuration:ANIMATION_DURATION];
                            } else {
                                float lastAngle = [self getAngleWithSpeed:self.lastSpeed];
                                [self doAnimationfromAngle:lastAngle toAngle:currentAngle withDuration:ANIMATION_DURATION];
                            }
                            //执行上传帧动画
                            [self startUpLoadAnimation];
                            
                            //保存值
                            [self.upDictionary setObject:data forKey:[data objectForKey:@"seq"]];
                            
                            //赋予速度
                            self.uploadSpeed.text = [self formatSpeed:speed];
                            
                            self.lastSpeed = speed;
                            
                        } else if ([[data objectForKey:@"status"]isEqualToString:@"finish"]) {
                            self.isUpFinish = YES;
                            
                            //执行指针动画
                            CGFloat speed =  [[data objectForKey:@"speed"]floatValue];
                            float currentAngle = [self getAngleWithSpeed:speed];
                            if (self.lastSpeed == -1) {
                                [self doAnimationfromAngle:62.0 toAngle:currentAngle withDuration:ANIMATION_DURATION];
                            } else {
                                float lastAngle = [self getAngleWithSpeed:self.lastSpeed];
                                [self doAnimationfromAngle:lastAngle toAngle:currentAngle withDuration:ANIMATION_DURATION];
                            }
                            //指针回到原点
                            [self recoverColorArray];
                            [self doAnimationfromAngle:currentAngle toAngle:62.0 withDuration:ANIMATION_DURATION];
                            
                            //停止上传帧动画
                            [self stopUpLoadAnimation];
                            
                            //                        //保存值
                            //                        [self.upDictionary setObject:data forKey:[data objectForKey:@"seq"]];
                            
                            //赋予速度
                            self.uploadSpeed.text = [self formatSpeed:speed];
                            
                            self.lastSpeed = 0;
                            
                            //开始测速动画
                            [self startDownLoadAnimation];
                            
                            
                        } else if ([[data objectForKey:@"status"]isEqualToString:@"error"]) {
                            //指针回到原点
                            float lastAngle = [self getAngleWithSpeed:self.lastSpeed];
                            [self recoverColorArray];
                            [self doAnimationfromAngle:lastAngle toAngle:62.0  withDuration:ANIMATION_DURATION];
                            
                            self.uploadSpeed.text = [self formatSpeed:self.lastSpeed];
                            [self stopUpLoadAnimation];
                            self.lastSpeed = 0;
                            [self startDownLoadAnimation];
                        }
                    }
                }else {
                     //上行finish－－开始下行
                    if (self.isDownpFinish) {
                        
//                        //上下行都finish
//                        if (self.isUpFinish && self.isDownpFinish) {
//                            self.isUpFinish = NO;
//                            self.isDownpFinish = NO;
//                            //返回原处
//                            CGFloat myLastSpeed = [self getAngleWithSpeed:self.lastSpeed];
//                            [self recoverColorArray];
//                            [self doAnimationfromAngle:myLastSpeed toAngle:62.0 withDuration:ANIMATION_DURATION];
//                            
//                            [self stopUpLoadAnimation];
//                            [self stopDownLoadAnimation];
//                            //定时器停止
//                            [self stopTimer];
//                            [self showSpeedResultViewAnimation];
//                            return;
//                        }
                        
                    } else {
                        //上行finish，下行没finish
                        if ([data objectForKey:@"dir"] && [data objectForKey:@"seq"] && [[data objectForKey:@"dir"] isEqualToString:@"down"]) {
                            if ([[data objectForKey:@"status"]isEqualToString:@"running"]) {
                                //执行指针动画
                                CGFloat speed =  [[data objectForKey:@"speed"]floatValue];
                                float currentAngle = [self getAngleWithSpeed:speed];
                                
                                float lastAngle = [self getAngleWithSpeed:self.lastSpeed];
                                [self doAnimationfromAngle:lastAngle toAngle:currentAngle withDuration:ANIMATION_DURATION];
                                
                                //执行下载帧动画
                                [self startDownLoadAnimation];
                                
                                //保存值
                                [self.downDictionary setObject:data forKey:[data objectForKey:@"seq"]];
                                
                                //赋予速度
                                self.downLoadSpeed.text = [self formatSpeed:speed];
                                
                                self.lastSpeed = speed;
                                
                            } else if ([[data objectForKey:@"status"]isEqualToString:@"finish"]) {
                                self.isDownpFinish = YES;
                                //执行指针动画
                                CGFloat speed =  [[data objectForKey:@"speed"]floatValue];
                                float currentAngle = [self getAngleWithSpeed:speed];
                                float lastAngle = [self getAngleWithSpeed:self.lastSpeed];
                                [self doAnimationfromAngle:lastAngle toAngle:currentAngle withDuration:ANIMATION_DURATION];
                                
                                //指针回到原点
                                [self recoverColorArray];
                                [self doAnimationfromAngle:currentAngle toAngle:62.0 withDuration:ANIMATION_DURATION];
                                
                                //停止下载帧动画
                                [self stopDownLoadAnimation];
                                
                                //保存值
                                //                        [self.downDictionary setObject:data forKey:[data objectForKey:@"seq"]];
                                
                                //赋予速度
                                self.downLoadSpeed.text = [self formatSpeed:speed];
                                [self stopTimer];
                                self.lastSpeed = 0;
                                
                            } else if ([[data objectForKey:@"status"]isEqualToString:@"error"]) {
                                //指针回到原点
                                float lastAngle = [self getAngleWithSpeed:self.lastSpeed];
                                [self recoverColorArray];
                                [self doAnimationfromAngle:lastAngle toAngle:62.0 withDuration:ANIMATION_DURATION];
                                
                                self.downLoadSpeed.text = [self formatSpeed:self.lastSpeed];
                                [self stopDownLoadAnimation];
                                [self stopTimer];
                                self.lastSpeed = 0;
                            }
                        }
                    }
                    
                }
                
                //上下行都finish
                if (self.isUpFinish && self.isDownpFinish) {
                    self.isUpFinish = NO;
                    self.isDownpFinish = NO;
                    //返回原处
                    CGFloat myLastSpeed = [self getAngleWithSpeed:self.lastSpeed];
                    [self recoverColorArray];
                    [self doAnimationfromAngle:myLastSpeed toAngle:62.0 withDuration:ANIMATION_DURATION];
                    
                    [self stopUpLoadAnimation];
                    [self stopDownLoadAnimation];
                    //定时器停止
                    [self stopTimer];
                    [self showSpeedResultViewAnimation];
                    [self doSpeed:nil];
                    return;
                }
                
                
            } else {
                //接口失败
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
                [self.speedTestButton setTitle:@"点击测速" forState:UIControlStateNormal];
                [self stopDownLoadAnimation];
                [self stopUpLoadAnimation];
            
                [self stopTimer];
                
                CGFloat myLastSpeed = [self getAngleWithSpeed:self.lastSpeed];
                [self recoverColorArray];
                [self doAnimationfromAngle:myLastSpeed toAngle:62.0 withDuration:ANIMATION_DURATION];
                [self doSpeed:nil];
#warning ---------计算平均值－－－－
#warning -----------ui适配，指针偏移轨道
               
            }
        }];
    }
}

#pragma mark - 根据速度得到角度
- (float)getAngleWithSpeed: (float)speed {
    float angle;
    if (speed >=0 && speed <=64) {
        angle = (62.0 + 30*speed/64);
        
    } else if (speed > 64 && speed <= 128) {
        angle = (62.0 + 30 + 30*(speed -64)/64);
        
    } else if (speed > 128 && speed <= 256) {
        angle = (62.0 + 60 + 30*(speed -128)/128);
        
    } else if (speed >256 && speed <= 512) {
        angle = (62.0 + 90 + 30*(speed -256)/256);
        
    } else if (speed > 512 && speed <= 1024) {
        angle = (62.0 + 120 + 30*(speed - 512)/512);
        
    } else if (speed > 1024 && speed <= 5*1024) {
        angle = (62.0 + 150 + 30*(speed - 1024)/4096);
        
    } else if (speed > 5*1024 && speed <=10*1024) {
        angle = (62.0 + 180 + 30*(speed - 5120)/5120);
        
    } else if (speed > 10 *1024) {
        //默认值？
        angle = (62.0 + 210 + 30*(12*1024 - 5120)/5120);
    }
    return angle;
}

#pragma  mark - 根据角度做动画
- (void)doAnimationfromAngle:(float)fromAngle toAngle :(float)toAngle withDuration:(float)duration {
    self.count += 1;
    if (self.count == 1) {
        //动画第一次，记录这个时间点
        self.date = [NSDate date];
    }
    /*
     1.springBounciness 弹簧弹力 取值范围为[0, 20]，默认值为4
     2.springSpeed 弹簧速度，速度越快，动画时间越短 [0, 20]，默认为12，和springBounciness一起决定着弹簧动画的效果
     3.dynamicsTension 弹簧的张力
     4.dynamicsFriction 弹簧摩擦
     5.dynamicsMass 质量 。张力，摩擦，质量这三者可以从更细的粒度上替代springBounciness和springSpeed控制弹簧动画的效果
     */
    POPSpringAnimation *popSpringAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    popSpringAnimation.fromValue = @(M_PI/180.0 * fromAngle);
    popSpringAnimation.toValue = @(M_PI/180.0 * toAngle);
    if (fromAngle <= 62.0) {
        popSpringAnimation.springBounciness = 1;
    } else {
        popSpringAnimation.springBounciness = 20;
    }
    popSpringAnimation.springSpeed = 20;
    popSpringAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
    };
    popSpringAnimation.delegate = self;
    [self.nodeImgView.layer pop_addAnimation:popSpringAnimation forKey:@"popSpringAnimation"];
}

- (void)pop_animationDidApply:(POPAnimation *)anim {

    NSString *str = [NSString stringWithFormat:@"%@",anim];
    NSArray * arr = [str componentsSeparatedByString:@";"];
    if (arr.count >0) {
        NSString *myStr = [NSString stringWithFormat:@"%@",arr[3]];
        NSString *string = [myStr substringFromIndex:15];
        //去掉空格
        NSString *valueStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        float radian = [valueStr floatValue];
        //    角度=弧度除以π再乘以180
        float currentAngle = radian / M_PI * 180;
//        NSLog(@"&&&&&&&&&&&&&&&&%f",currentAngle);
        [self drawRadianWithAngle:currentAngle];
    }
    
    /*
    //大鹏方法
    CGFloat radius = atan2f(self.nodeImgView.transform.b, self.nodeImgView.transform.a);
    CGFloat degree = radius * (180 / M_PI);
    NSLog(@"&&&&&&&&&&&&&&&&%f",degree);
    
#warning ----------测试
    if (degree < 0) {
        degree = 360 - ceilf(degree);
    }
    [self drawRadianWithAngle:degree];
     */
}

- (void)drawRadianWithAngle:(float)angle {
    [self recoverColorArray];
    if (angle >62.0 && angle <= 90) {
        [self.colorArray replaceObjectAtIndex:0 withObject:COLOR_HEX(0xffffff)];
        self.circleBgView.acceptColorArr = self.colorArray;
        [self.circleBgView setNeedsDisplay];
        
    } else if (angle > 90 && angle <= 120) {
        [self.colorArray replaceObjectAtIndex:0 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:1 withObject:COLOR_HEX(0xffffff)];
        self.circleBgView.acceptColorArr = self.colorArray;
        [self.circleBgView setNeedsDisplay];
        
    } else if (angle > 120 && angle <= 150) {
        [self.colorArray replaceObjectAtIndex:0 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:1 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:2 withObject:COLOR_HEX(0xffffff)];
        self.circleBgView.acceptColorArr = self.colorArray;
        [self.circleBgView setNeedsDisplay];
        
        
    } else if (angle >150 && angle <= 180) {
        [self.colorArray replaceObjectAtIndex:0 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:1 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:2 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:3 withObject:COLOR_HEX(0xffffff)];
        self.circleBgView.acceptColorArr = self.colorArray;
        [self.circleBgView setNeedsDisplay];
        
    } else if (angle > 180 && angle <= 210) {
        [self.colorArray replaceObjectAtIndex:0 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:1 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:2 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:3 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:4 withObject:COLOR_HEX(0xffffff)];
        self.circleBgView.acceptColorArr = self.colorArray;
        [self.circleBgView setNeedsDisplay];
        
        
    } else if (angle > 210 && angle <= 240) {
        [self.colorArray replaceObjectAtIndex:0 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:1 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:2 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:3 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:4 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:5 withObject:COLOR_HEX(0x00ffff)];
        self.circleBgView.acceptColorArr = self.colorArray;
        [self.circleBgView setNeedsDisplay];
        
        
    } else if (angle > 240 && angle <=270) {
        [self.colorArray replaceObjectAtIndex:0 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:1 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:2 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:3 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:4 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:5 withObject:COLOR_HEX(0x00ffff)];
        [self.colorArray replaceObjectAtIndex:6 withObject:COLOR_HEX(0x00ffff)];
        self.circleBgView.acceptColorArr = self.colorArray;
        [self.circleBgView setNeedsDisplay];
        
    } else if (angle > 270 && angle < 300) {
        [self.colorArray replaceObjectAtIndex:0 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:1 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:2 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:3 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:4 withObject:COLOR_HEX(0xffffff)];
        [self.colorArray replaceObjectAtIndex:5 withObject:COLOR_HEX(0x00ffff)];
        [self.colorArray replaceObjectAtIndex:6 withObject:COLOR_HEX(0x00ffff)];
        [self.colorArray replaceObjectAtIndex:7 withObject:COLOR_HEX(0x0ce853)];
        self.circleBgView.acceptColorArr = self.colorArray;
        [self.circleBgView setNeedsDisplay];
        
    }
}


#pragma mark - 测速／取消测速
- (IBAction)doSpeed:(UIButton *)sender {

    self.speedFlag = !self.speedFlag;
    if (self.speedFlag) {
        
        [self.speedTestButton setTitle:@"取消测速" forState:UIControlStateNormal];
        
        [self.upDictionary removeAllObjects];
        [self.downDictionary removeAllObjects];
        
        [self loadData];
        
    } else {
        
        [self.speedTestButton setTitle:@"点击测速" forState:UIControlStateNormal];
        [self stopDownLoadAnimation];
        [self stopUpLoadAnimation];
        
        [self stopTimer];
#warning --------抽出方法-－－－－－2
        //返回原处
        CGFloat myLastSpeed = [self getAngleWithSpeed:self.lastSpeed];
        [self recoverColorArray];
        [self doAnimationfromAngle:myLastSpeed toAngle:62.0 withDuration:ANIMATION_DURATION];
    }
}

#pragma mark - 隐藏 测速结果
- (IBAction)hideSpeedResult:(UIButton *)sender {
    [self hideSpeedResultViewAnimation];
}

#pragma mark - 测速结果 - 显示
- (void)showSpeedResultViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"speedResultTopCons"]) {
            tempCons.constant = 0;
        }
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.speedResultBgView.top = 0;
    } completion:^(BOOL finished) {
    }];
    //带宽
    NSString *branWidthStr = [NSString stringWithFormat:@"当前网速相当于%@带宽",[self bandwidthWithUpSpeedStr:self.uploadSpeed.text andWithDownSpeedStr:self.downLoadSpeed.text]];
    NSMutableAttributedString *branWidthAttStr = [[NSMutableAttributedString alloc]initWithString:branWidthStr];
    [branWidthAttStr setAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor] , NSFontAttributeName : [UIFont systemFontOfSize:12.0]} range:NSMakeRange(0, 7)];
    [branWidthAttStr setAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor] , NSFontAttributeName : [UIFont systemFontOfSize:12.0]} range:NSMakeRange(branWidthAttStr.length-2, 2)];
    self.currentSpeedStatusLabel.attributedText = branWidthAttStr;
}

#pragma mark - 测速结果 - 隐藏
- (void)hideSpeedResultViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if (SCREEN_HEIGHT <= 568) {
            if([tempCons.identifier isEqualToString: @"speedResultTopCons"]) {
                tempCons.constant = -240;
            }
        } else {
            if([tempCons.identifier isEqualToString: @"speedResultTopCons"]) {
                tempCons.constant = -294;
            }
        }
    }
    [UIView animateWithDuration:0.3f animations:^{
         if (SCREEN_HEIGHT <= 568) {
             self.speedResultBgView.top = -240;
         } else {
             self.speedResultBgView.top = -294;
         }
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 开始下载动画
- (void)startDownLoadAnimation {
    [self.downLoadImgView setAnimationImages:self.downPictureArray];
    [self.downLoadImgView setAnimationDuration:0.7f];
    [self.downLoadImgView setAnimationRepeatCount:0];
    [self.downLoadImgView startAnimating];
}

#pragma mark - 停止下载动画
- (void) stopDownLoadAnimation {
    [self.downLoadImgView stopAnimating];
}

#pragma mark - 开始上传动画
- (void)startUpLoadAnimation {
    [self.upLoadImgView setAnimationImages:self.uploadPictureArray];
    [self.upLoadImgView setAnimationDuration:0.7f];
    [self.upLoadImgView setAnimationRepeatCount:0];
    [self.upLoadImgView startAnimating];
}

#pragma mark - 停止上传动画
- (void) stopUpLoadAnimation {
    [self.upLoadImgView stopAnimating];
}

#pragma mark - 求带宽
- (NSString *)bandwidthWithUpSpeedStr:(NSString *)upSpeedStr andWithDownSpeedStr:(NSString *)downSpeedStr {
    float floatUpSpeed;
    float floatDownSpeed;
    if ([[upSpeedStr substringWithRange:NSMakeRange(upSpeedStr.length-4, 4)] isEqualToString:@"KB/s"]) {
        floatUpSpeed = [[upSpeedStr substringToIndex:upSpeedStr.length-4]floatValue];
    } else if ([[upSpeedStr substringWithRange:NSMakeRange(upSpeedStr.length-4, 4)] isEqualToString:@"MB/s"]) {
        floatUpSpeed = [[upSpeedStr substringToIndex:upSpeedStr.length-4]floatValue] *1024;
    }
    
    if ([[downSpeedStr substringWithRange:NSMakeRange(downSpeedStr.length-4, 4)] isEqualToString:@"KB/s"]) {
        floatDownSpeed = [[downSpeedStr substringToIndex:downSpeedStr.length-4]floatValue];
    } else if ([[downSpeedStr substringWithRange:NSMakeRange(downSpeedStr.length-4, 4)] isEqualToString:@"MB/s"]) {
        floatDownSpeed = [[downSpeedStr substringToIndex:downSpeedStr.length-4]floatValue] *1024;
    }
    
    float maxSpeed = MAX(floatUpSpeed, floatDownSpeed);
    //求带宽
    NSString *bandwidth;
   float speed = maxSpeed * 8 / 1024;
    if (speed < 1024) {
        bandwidth = [NSString stringWithFormat:@"%.1fM",speed];
    } else {
        bandwidth = [NSString stringWithFormat:@"%.1fG",speed/1024.0f];
    }
    return bandwidth;
}

#pragma mark - 格式化速度
- (NSString *)formatSpeed:(CGFloat)speedValue
{
    NSString *trafficString = nil;
    if (speedValue >= 1024.0f) {
        trafficString = [NSString stringWithFormat:@"%.1fMB/s", speedValue / 1024.0f];
    } else {
        trafficString = [NSString stringWithFormat:@"%.1fKB/s", speedValue];
    }
    return trafficString;
}

#pragma mark - 平均速度
- (CGFloat)avgSpeedCalWithSpeedDict:(NSMutableDictionary *)speedDict
{
    // v4.0开始，调整为取最大值
    int i = 0;
    CGFloat max = 0;
    for (NSDictionary *stDict in [speedDict allValues]) {
        if ([[stDict objectForKey:@"status"] isEqualToString:@"running"]) {
            max = ([[stDict objectForKey:@"speed"] floatValue] > max) ? [[stDict objectForKey:@"speed"] floatValue] : max;
        }
        i++;
    }
    return max;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
