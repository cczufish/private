//
//  HWFDeviceInfoCell.m
//  HiWiFi
//
//  Created by dp on 14-5-14.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFDeviceInfoCell.h"

//#import "RTLabel.h"
//#import "HWFTools.h"

#import "HWFDeviceListModel.h"
#import "UIViewExt.h"

@interface HWFDeviceInfoCell ()

@property (strong, nonatomic) HWFDeviceListModel *deviceModel;
@property (assign, nonatomic) BOOL dateFlag;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UIView *durationView;
//@property (weak, nonatomic) IBOutlet UIImageView *offlineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *companyIconImageView;

@property (strong, nonatomic) UILabel *durationLabel;

@property (assign, nonatomic) BOOL isControlViewShow;
@property (strong, nonatomic) UIView *controlView;

@property (weak, nonatomic) IBOutlet UIImageView *speedLimitIcon; // 限速标志
@property (weak, nonatomic) IBOutlet UIImageView *networkImageView;

@property (weak, nonatomic) IBOutlet UILabel *trafficUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *trafficDownLabel;


@end

@implementation HWFDeviceInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{

    [super layoutSubviews];
//    self.deviceModel.trafficDown = 10000;
//    self.deviceModel.trafficUp = 2560;
    NSString *upString = [NSString stringWithFormat:@"上行%@",[self formatTraffic:self.deviceModel.trafficUp isOnline:self.deviceModel.isOnline]];
    NSMutableAttributedString *upAttString = [[NSMutableAttributedString alloc]initWithString:upString];
    [upAttString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.600 alpha:1.000] , NSFontAttributeName : [UIFont systemFontOfSize:8.0]} range:NSMakeRange(0, 2)];
    [upAttString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.600 alpha:1.000] , NSFontAttributeName : [UIFont systemFontOfSize:8.0]} range:NSMakeRange(upString.length-4, 4)];
    NSString *downString = [NSString stringWithFormat:@"下行%@",[self formatTraffic:self.deviceModel.trafficDown isOnline:self.deviceModel.isOnline]];
    NSMutableAttributedString *downAttString = [[NSMutableAttributedString alloc]initWithString:downString];
    [downAttString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.600 alpha:1.000] , NSFontAttributeName : [UIFont systemFontOfSize:8.0]} range:NSMakeRange(0, 2)];
    [downAttString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.600 alpha:1.000] , NSFontAttributeName : [UIFont systemFontOfSize:8.0]} range:NSMakeRange(downString.length-4, 4)];
    self.trafficUpLabel.attributedText = upAttString;
    self.trafficDownLabel.attributedText = downAttString;
    
    if (!self.controlView) {
        self.controlView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.width, 0, 174, 70)];
        self.controlView.backgroundColor = [UIColor clearColor];
        
        UIButton *qosButton = [UIButton buttonWithType:UIButtonTypeCustom];
        qosButton.frame = CGRectMake(0, 0, 87, 70);
        qosButton.backgroundColor = COLOR_GRAY(204);
        [qosButton setTitle:@"限速" forState:UIControlStateNormal];
        [qosButton setTitleColor:COLOR_GRAY(102) forState:UIControlStateNormal];
        [qosButton addTarget:self action:@selector(clickQosButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.controlView addSubview:qosButton];
        
        UIButton *renameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        renameButton.frame = CGRectMake(87, 0, 87, 70);
        renameButton.backgroundColor = COLOR_HEX(0x2ECDA5);
        [renameButton setTitle:@"改名" forState:UIControlStateNormal];
        [renameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [renameButton addTarget:self action:@selector(clickRenameButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.controlView addSubview:renameButton];
        
        [self addSubview:self.controlView];
    }
    
    if (self.isControlViewShow) {
        self.isControlViewShow = NO;
        self.contentView.left = self.contentView.left+self.controlView.width;
        self.controlView.left = self.controlView.left+self.controlView.width;
    }
    
    if (self.showControlViewFlag) {
        [self showControlViewWithoutAnimation];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.contentView addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.contentView addGestureRecognizer:swipeLeftGesture];
    
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.contentView addGestureRecognizer:swipeRightGesture];
}

//点击事件
- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    
    if (self.isControlViewShow) {
        [self hideControlView];
    } else {
        if ([self.delegate respondsToSelector:@selector(clickCell:withDeviceModel:dateFlag:)]) {
            [self.delegate clickCell:self withDeviceModel:self.deviceModel dateFlag:self.dateFlag];
        }
    }
     
}

//滑动出现：改名＋限速
- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)gestureRecognizer
{
    /*
    switch (gestureRecognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            if (!self.isControlViewShow) {
                [self showControlView];
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionRight:
        {
            if (self.isControlViewShow) {
                [self hideControlView];
            }
        }
            break;
        default:
            break;
    }
    */
}

- (void)showControlViewWithoutAnimation
{
    if (self.isControlViewShow) {
        return;
    }
    
    self.isControlViewShow = YES;
    self.contentView.left = self.contentView.left-self.controlView.width;
    self.controlView.left = self.controlView.left-self.controlView.width;
    
    if ([self.delegate respondsToSelector:@selector(handleShowControlViewWithCell:)]) {
        [self.delegate performSelector:@selector(handleShowControlViewWithCell:) withObject:self];
    }
}

- (void)showControlView
{
    if (self.isControlViewShow) {
        return;
    }
    
    self.isControlViewShow = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.left = self.contentView.left-self.controlView.width;
        self.controlView.left = self.controlView.left-self.controlView.width;
    } completion:^(BOOL finished) {
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(handleShowControlViewWithCell:)]) {
        [self.delegate performSelector:@selector(handleShowControlViewWithCell:) withObject:self];
    }
}

- (void)hideControlView
{
    if (!self.isControlViewShow) {
        return;
    }
    
    self.isControlViewShow = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.left = self.contentView.left+self.controlView.width;
        self.controlView.left = self.controlView.left+self.controlView.width;
    } completion:^(BOOL finished) {
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(handleHideControlViewWithCell:)]) {
        [self.delegate performSelector:@selector(handleHideControlViewWithCell:) withObject:self];
    }
}

- (void)clickQosButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickQosWithCell:withDeviceModel:)]) {
        [self.delegate performSelector:@selector(clickQosWithCell:withDeviceModel:) withObject:self withObject:self.deviceModel];
    }
}

- (void)clickRenameButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickRenameWithCell:withDeviceModel:)]) {
        [self.delegate performSelector:@selector(clickRenameWithCell:withDeviceModel:) withObject:self withObject:self.deviceModel];
    }
}

- (void)reloadCellWithModel:(HWFDeviceListModel *)aDeviceModel dateFlag:(BOOL)dateFlag
{
    self.deviceModel = aDeviceModel;
    self.dateFlag = dateFlag;

    if ([aDeviceModel.name isEqualToString:@""]) {
        self.deviceNameLabel.text = @"未知";
    } else {
        self.deviceNameLabel.text = aDeviceModel.name;
    }
    self.macLabel.text = aDeviceModel.MAC;
    
    if (self.deviceModel.QoSStatus) {
        self.speedLimitIcon.hidden = NO;
    } else {
        self.speedLimitIcon.hidden = YES;
    }
    
    //是否在线
    if (self.deviceModel.isOnline) {
        self.deviceNameLabel.textColor = COLOR_RGB(48, 176, 248);
        self.macLabel.textColor = COLOR_RGB(153, 153, 153);
        self.trafficDownLabel.textColor = COLOR_RGB(48, 176, 248);
        self.trafficUpLabel.textColor = COLOR_RGB(48, 176, 248);
    } else {
        self.deviceNameLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        self.macLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        self.trafficDownLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        self.trafficUpLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    }

    //网络图片
    if (!dateFlag || !self.deviceModel.isOnline) {
        [self.networkImageView setImage:nil];
    } else if (self.deviceModel.connectType == ConnectTypeLine) {
        [self.networkImageView setImage:[UIImage imageNamed:@"lan"]];
    } else if (self.deviceModel.connectType == ConnectTypeWiFi_5G) {
#warning -----------缺少5g的图片 ＋ 限速－－－－－－－－－－－－
        switch (self.deviceModel.signal / 20) {
            case 0:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal0.png"]];
                break;
            case 1:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal1.png"]];
                break;
            case 2:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal2.png"]];
                break;
            case 3:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal3.png"]];
                break;
            case 4:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal4.png"]];
                break;
            case 5:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal4.png"]];
                break;
            default:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal0.png"]];
                break;
        }
    } else {
        switch (self.deviceModel.signal / 20) {
            case 0:
                [self.networkImageView setImage:[UIImage imageNamed:@"wifi-0"]];
                break;
            case 1:
                [self.networkImageView setImage:[UIImage imageNamed:@"wifi-1"]];
                break;
            case 2:
                [self.networkImageView setImage:[UIImage imageNamed:@"wifi-2"]];
                break;
            case 3:
                [self.networkImageView setImage:[UIImage imageNamed:@"wifi-3"]];
                break;
            case 4:
                [self.networkImageView setImage:[UIImage imageNamed:@"wifi-4"]];
                break;
            case 5:
                [self.networkImageView setImage:[UIImage imageNamed:@"wifi-4"]];
                break;
            default:
                [self.networkImageView setImage:[UIImage imageNamed:@"wifi-0"]];
                break;
        }
    }
    
    /*
    
    if (self.deviceModel.isOnline) {
        self.deviceNameLabel.textColor = __COLOR_RGB(70, 152, 236);
        self.macLabel.textColor = __COLOR_GRAY(102);
    } else {
        self.deviceNameLabel.textColor = __COLOR_GRAY(184);
        self.macLabel.textColor = __COLOR_GRAY(184);
    }
    
    NSString *prefix = @"comid_";
    NSString *suffix = self.deviceModel.isOnline ? @"_online" : @"_offline";
//    NSString *companyImageName = [NSString stringWithFormat:@"%@%d%@", prefix, self.deviceModel.comId, suffix];
    NSString *placeholderImageName = [NSString stringWithFormat:@"%@0%@", prefix, suffix];
    
    UIImage *companyIconImage = [UIImage imageNamed:companyImageName];
    UIImage *placeholderImage = [UIImage imageNamed:placeholderImageName];
    self.companyIconImageView.image = companyIconImage ? companyIconImage : placeholderImage;
    
    
    NSString *deviceName = @"  ";
    self.deviceNameLabel.text = deviceName;
    self.macLabel.text = self.deviceModel.mac;
    
    double traffic = 0;
    if (dateFlag && self.deviceModel) {
        traffic = self.deviceModel.trafficUp + self.deviceModel.trafficDown;
    }
    [self.durationLabel setText:[self formatTraffic:traffic isOnline:self.deviceModel.isOnline]];
    
    if (self.deviceModel.qosStatus) {
        self.deviceNameLabel.width = 120.0;
        
        CGSize size = [deviceName sizeWithFont:self.deviceNameLabel.font constrainedToSize:self.deviceNameLabel.size lineBreakMode:self.deviceNameLabel.lineBreakMode];
        self.speedLimitIcon.left = self.deviceNameLabel.left + size.width + 5;
        self.speedLimitIcon.hidden = NO;
    } else {
        self.deviceNameLabel.width = 140.0;
        
        self.speedLimitIcon.hidden = YES;
    }
    
    if (!dateFlag || !self.deviceModel.isOnline || self.deviceModel.type==0) {
        [self.networkImageView setImage:nil];
    } else if (self.deviceModel.type == HWFDeviceTypeLine) {
        [self.networkImageView setImage:[UIImage imageNamed:@"rj45_icon01.png"]];
    } else if (self.deviceModel.type == HWFDeviceTypeWiFi && self.deviceModel.wifiType == HWFDeviceWiFi_5G) {
        switch (self.deviceModel.signal / 20) {
            case 0:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal0.png"]];
                break;
            case 1:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal1.png"]];
                break;
            case 2:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal2.png"]];
                break;
            case 3:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal3.png"]];
                break;
            case 4:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal4.png"]];
                break;
            case 5:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal4.png"]];
                break;
            default:
                [self.networkImageView setImage:[UIImage imageNamed:@"5g-signal0.png"]];
                break;
        }
    } else {
        switch (self.deviceModel.signal / 20) {
            case 0:
                [self.networkImageView setImage:[UIImage imageNamed:@"myhiwifi2_icon_wifi_0.png"]];
                break;
            case 1:
                [self.networkImageView setImage:[UIImage imageNamed:@"myhiwifi2_icon_wifi_1.png"]];
                break;
            case 2:
                [self.networkImageView setImage:[UIImage imageNamed:@"myhiwifi2_icon_wifi_2.png"]];
                break;
            case 3:
                [self.networkImageView setImage:[UIImage imageNamed:@"myhiwifi2_icon_wifi_3.png"]];
                break;
            case 4:
                [self.networkImageView setImage:[UIImage imageNamed:@"myhiwifi2_icon_wifi_4.png"]];
                break;
            case 5:
                [self.networkImageView setImage:[UIImage imageNamed:@"myhiwifi2_icon_wifi_4.png"]];
                break;
            default:
                [self.networkImageView setImage:[UIImage imageNamed:@"myhiwifi2_icon_wifi_0.png"]];
                break;
        }
    }
     */
}

- (NSString *)formatTraffic:(double)traffic isOnline:(BOOL)isOnline
{
    NSString *trafficText = nil;
//    if (isOnline) {
//       self.durationLabel.textColor =  COLOR_HEX(0x666666);
//    } else {
//        self.durationLabel.textColor =  COLOR_HEX(0xB8B8B8);
//    }
    if (!isOnline || traffic < 0.1) {
        trafficText = @"0KB/s";
    } else if (traffic < 100) {
        trafficText = [NSString stringWithFormat:@"%.1fKB/s",traffic];
    } else if (traffic < 1024) {
        trafficText = [NSString stringWithFormat:@"%.fKB/s",traffic];
    } else if (traffic < 1024*1024) {
        trafficText = [NSString stringWithFormat:@"%.1fMB/s", traffic/1024.0];
    } else if (traffic < 1024*1024*100) {
        trafficText = [NSString stringWithFormat:@"%.fMB/s", traffic/1024.0];
    } else if (traffic < 1024*1024*1024) {
        trafficText = [NSString stringWithFormat:@"%.1fGB/s", traffic/1024.0/1024.0];
    }
    return trafficText;
}

- (NSString *)durationWithTime:(NSInteger)time isOnline:(BOOL)isOnline
{
    NSString *durationText = nil;
    NSString *duration = [self formatTime:time];
    NSArray *durationArr = [duration componentsSeparatedByString:@":"];
    if (isOnline) {
        durationText = [NSString stringWithFormat:@"%@<font size=12 color='#C6C6C6'> h</font> %@<font size=12 color='#C6C6C6'> min</font>", durationArr[0], durationArr[1]];
    } else {
        durationText = [NSString stringWithFormat:@"<font color='#C6C6C6'>%@<font size=12 color='#C6C6C6'> h</font> %@<font size=12 color='#C6C6C6'> min</font></font>", durationArr[0], durationArr[1]];
    }
    return durationText;
}

- (NSString *)formatTime:(NSInteger)aTime
{
    NSInteger hour = aTime / 60;
    NSInteger minute = aTime % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", hour, minute];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImageView *lineImageView=[[UIImageView alloc] initWithFrame:self.contentView.frame];
    [self.contentView addSubview:lineImageView];
    
    UIGraphicsBeginImageContext(lineImageView.frame.size);
    [lineImageView.image drawInRect:CGRectMake(0, 0, lineImageView.frame.size.width, lineImageView.frame.size.height)];
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.5f);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 200.0/255.0, 200.0/255.0, 200.0/255.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, self.contentView.height);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), SCREEN_WIDTH, self.contentView.height);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    lineImageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
