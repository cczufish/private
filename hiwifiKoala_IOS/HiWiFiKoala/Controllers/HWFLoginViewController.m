//
//  HWFLoginViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFLoginViewController.h"
#import "HWFMobileRegisterViewController.h"
#import "HWFNavigationController.h"
#import "HWFService+User.h"
#import "HWFUser.h"
#import "UIViewExt.h"
#import "HWFService+Router.h"
#import "HWFLoginFaiedlViewController.h"
#import "HWFBindWebViewController.h"

#define HEIGHT_EMAILTABLEVIEW_CELL 20.0f


@interface HWFLoginViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,HWFBindWebViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *foundPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *describeBtn;
@property (weak, nonatomic) IBOutlet UIButton *maskButton;
@property (nonatomic,assign) BOOL isBeingUp;

//用户名补全
@property(nonatomic,strong)NSMutableArray *resultData;
@property(nonatomic,strong)NSArray *emailArray;
@property(nonatomic,strong)NSString *subStr;


@property (weak, nonatomic) IBOutlet UITableView *loginTableView;

//连接失败页
@property (weak, nonatomic) IBOutlet UIButton *connectFailedMaskButton;
@property (strong, nonatomic) IBOutlet UIView *connectedFailedBgView;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel3;

@property (weak, nonatomic) IBOutlet UIButton *connectedButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

//立即绑定页

//@property (weak, nonatomic) IBOutlet UIButton *bindMaskButton;
//@property (weak, nonatomic) IBOutlet UILabel *routerNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *bindTipLabel;
//@property (weak, nonatomic) IBOutlet UIButton *bindButton;
//@property (strong, nonatomic) IBOutlet UIView *bindBgView;


@end

@implementation HWFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
}

- (void)initData {
    self.emailArray = [[NSArray alloc]initWithObjects:@"@sina.com",@"@163.com",@"@qq.com",@"@126.com",@"@vip.sina.com",@"@hotmail.com",@"@gmail.com",@"@sohu.com",@"@139.com",@"@wo.com",@"@189.com",@"@21cn.com",nil];
    self.resultData = [NSMutableArray arrayWithArray:self.emailArray];
    
}

- (void)initView {
    
    NSLog(@"宽度宽度：%f,高度高度：%f",SCREEN_WIDTH,SCREEN_HEIGHT);
    
    _isBeingUp = NO;
    self.title = @"登录";
    self.userNameTextField.placeholder = @"手机号/用户名/邮箱";
    self.passwordTextField.placeholder = @"密码";
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.foundPwdBtn setTitle:@"找回密码?" forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.describeBtn setTitle:@"智能路由器都能做些什么?" forState:UIControlStateNormal];
    
    UIImage *loginImage = [[UIImage imageNamed:@"btn1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highLoginImage = [[UIImage imageNamed:@"btn3"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:highLoginImage forState:UIControlStateHighlighted];
    
    UIImage *registerImage = [[UIImage imageNamed:@"btn6"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highRegisterImage = [[UIImage imageNamed:@"btn7"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.registerBtn setBackgroundImage:registerImage forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:highRegisterImage forState:UIControlStateHighlighted];
    
    
    //用户名补全
    self.loginTableView .alpha = 0.8;
    self.loginTableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loginTableView .hidden = YES;
    
    //通知，监听文字是否改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unameDidChange:) name:UITextFieldTextDidChangeNotification object:self.userNameTextField];
    
    //为了适配，改约束
    NSArray *contraints = self.view.constraints;
    for (NSLayoutConstraint *contraint in contraints) {
        if (contraint.constant == 2 && contraint.firstAttribute == NSLayoutAttributeBottom && contraint.secondAttribute ==  NSLayoutAttributeBottom ) {
            if (SCREEN_HEIGHT <= 480) {
                contraint.constant = 2;
            } else if (SCREEN_HEIGHT <= 568) {
                contraint.constant = 40;
            } else {
                contraint.constant = 80;
            }
        }
        
        if (contraint.constant == 15 && contraint.firstAttribute == NSLayoutAttributeTop  && contraint.secondAttribute ==  NSLayoutAttributeTop ) {
            if (SCREEN_HEIGHT <= 480) {
                contraint.constant = 15;
            } else if (SCREEN_HEIGHT <= 568) {
                contraint.constant = 40;
            } else {
                 contraint.constant = 80;
            }
        }
    }
    
    //连接失败页
    self.tipLabel1.text = @"AppleNate 你好!";
    self.tipLabel2.text = @"未发现可以管理的路由器";
    self.tipLabel3.text = @"请连接你的极路由";
    [self.connectedButton setTitle:@"我已经连上了" forState:UIControlStateNormal];
    UIImage *connectedImage = [[UIImage imageNamed:@"btn1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highConnectedImage = [[UIImage imageNamed:@"btn3"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.connectedButton setBackgroundImage:connectedImage forState:UIControlStateNormal];
    [self.connectedButton setBackgroundImage:highConnectedImage forState:UIControlStateHighlighted];
    
    [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    UIImage *logoutImage = [[UIImage imageNamed:@"btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highLogoutImage = [[UIImage imageNamed:@"btn4"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.logoutButton setBackgroundImage:logoutImage forState:UIControlStateNormal];
    [self.logoutButton setBackgroundImage:highLogoutImage forState:UIControlStateHighlighted];
    // 约束
    [self.view addSubview:self.connectedFailedBgView];
    self.connectedFailedBgView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem: self.connectedFailedBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:470];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem: self.connectedFailedBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-470];
    topConstraint.identifier = @"connectFailedTopCons";
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem: self.connectedFailedBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: self.connectedFailedBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraints:@[heightConstraint,topConstraint,leadingConstraint,trailingConstraint]];
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
    
    //绑定
//    self.routerNameLabel.text = @"HiWiFi_0假数据";
//    self.bindTipLabel.text = @"发现一台极路由确定绑定她吗?";
//    [self.bindButton setTitle:@"立即绑定" forState:UIControlStateNormal];
//    UIImage *bindImage = [[UIImage imageNamed:@"btn1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
//    UIImage *highBindImage = [[UIImage imageNamed:@"btn3"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
//    [self.bindButton setBackgroundImage:bindImage forState:UIControlStateNormal];
//    [self.bindButton setBackgroundImage:highBindImage forState:UIControlStateHighlighted];
//    //约束
//    [self.view addSubview:self.bindBgView];
//    self.bindBgView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *bindheightConstraint = [NSLayoutConstraint constraintWithItem: self.bindBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:470];
//    NSLayoutConstraint *bindtopConstraint = [NSLayoutConstraint constraintWithItem: self.bindBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-470];
//    bindtopConstraint.identifier = @"bindTopCons";
//    NSLayoutConstraint *bindleadingConstraint = [NSLayoutConstraint constraintWithItem: self.bindBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
//    NSLayoutConstraint *bindtrailingConstraint = [NSLayoutConstraint constraintWithItem: self.bindBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
//    [self.view addConstraints:@[bindheightConstraint,bindtopConstraint,bindleadingConstraint,bindtrailingConstraint]];
//    [self.view layoutIfNeeded];
//    [self.view setNeedsUpdateConstraints];
    
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_EMAILTABLEVIEW_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, cell.contentView.width, HEIGHT_EMAILTABLEVIEW_CELL)];
        emailLabel.tag = 10010;
        emailLabel.font = self.userNameTextField.font;
        emailLabel.textAlignment = NSTextAlignmentLeft;
        emailLabel.textColor = self.userNameTextField.textColor;
        emailLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:emailLabel];
    }
    
    UILabel *emailLabel = (UILabel *)[cell.contentView viewWithTag:10010];
    NSString *email = self.userNameTextField.text;
    NSRange range = [email rangeOfString:@"@"];
    
    if (range.location != NSNotFound) {
        NSString *prefix = [email substringWithRange:NSMakeRange(0, range.location)];
        CGSize unameSize = [prefix sizeWithFont:self.userNameTextField.font constrainedToSize:self.userNameTextField.bounds.size lineBreakMode:NSLineBreakByCharWrapping];
        emailLabel.left = unameSize.width+6;
    }
    
    emailLabel.text = [self.resultData objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark-监听textFeild里面文字的变化
- (void)unameDidChange:(NSNotification *)notify
{
    NSString *text = self.userNameTextField.text;
    if (text.length == 0) {
        self.loginTableView.hidden = YES;
        self.resultData = [NSMutableArray arrayWithArray:self.emailArray];
    }else
    {
        
        //截取字符串
        NSRange r = [self.userNameTextField.text rangeOfString:@"@"];
        if (r.length > 0)
        {
            self.loginTableView.hidden = NO;
            //@后面的字符串
            NSString *conditionStr = [self.userNameTextField.text substringFromIndex:r.location];
            //          NSString *conditionStr = [_searchBar.text substringWithRange:r];//这样写就有点问题了
            //@前面的字符串
            self.subStr = [self.userNameTextField.text substringToIndex:r.location];
            
            if (self.subStr.length == 0) {
                self.loginTableView.hidden = YES;
                return;
            }
            
            NSString *string = [NSString stringWithFormat:@"self like [c]'%@*'",conditionStr];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:string];
            
            NSArray *result = [self.emailArray filteredArrayUsingPredicate:predicate];
            
            if ([[result firstObject] isEqualToString:conditionStr]) {
                self.loginTableView.hidden = YES;
                return;
            }
            
            if (result.count > 0)
            {
                [_resultData removeAllObjects];
                self.resultData = [NSMutableArray arrayWithArray:result];
//                self.loginTableView.height = (_resultData.count>5?5:_resultData.count) * HEIGHT_EMAILTABLEVIEW_CELL;
                //修改约束的高度
                NSArray *contraints = self.view.constraints;
                for (NSLayoutConstraint *contraint in contraints) {
                    if (contraint.constant == 100 && contraint.firstAttribute == NSLayoutAttributeHeight && contraint.relation ==  NSLayoutRelationEqual) {
                        if (_resultData.count > 5) {
                            contraint.constant = 5 * HEIGHT_EMAILTABLEVIEW_CELL;
                        } else {
                            contraint.constant = _resultData.count * HEIGHT_EMAILTABLEVIEW_CELL;
                        }
                    }
                }
                
                self.loginTableView.hidden = NO;
            }else
            {
                self.loginTableView.hidden = YES;
            }
        } else {
            self.loginTableView.hidden = YES;
            return;
        }
        
    }
    [self.loginTableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.userNameTextField.text = [self.subStr stringByAppendingString:self.resultData[indexPath.row]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.hidden = YES;
}


- (void)upwardsElements {
    _isBeingUp = YES;
    [self.maskButton setHidden:NO];
}

- (void)downwardsElements {
    [self.maskButton setHidden:YES];
    _isBeingUp = NO;
}

//mask
- (IBAction)maskAction:(UIButton *)sender {
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    if (_isBeingUp) {
        [self downwardsElements];
    }
}
#pragma mark - 登录
- (IBAction)doLogin:(UIButton *)sender {
    
    [self loadingViewShow];
    [[HWFService defaultService] loginWithIdentity:self.userNameTextField.text password:self.passwordTextField.text completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
//    [[HWFService defaultService] loginWithIdentity:@"blueachaog@hotmail.com" password:@"123456" completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
//        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            NSString *mac = [HWFTool MAC4ConnectedWiFi];
            //走绑定流程
            [[HWFService defaultService]loadBindRoutersWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                NSLog(@"===============%@",data);
                NSLog(@"+++++++++++++%d",[[data objectForKey:@"routers"] count]);
                if ([[data objectForKey:@"routers"] count] <= 0) {//没有绑定任何路由器
                    NSLog(@"路由器等等等等等于0台");
                    //查看当前路由器是不是被绑定了
                    [[HWFService defaultService]loadBindUserWithUser:[HWFUser defaultUser] MAC:mac completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                        if (code == CODE_SUCCESS) {
                            NSLog(@"++++++++++++++%@",data);
                            if ([[[data objectForKey:@"data"]objectForKey:@"is_bind"]boolValue]) {
                                //被绑定了
                                [self showConnectFailedViewAnimation];
                            } else {
                                //没被绑定
                                [self doBind];
//                                [self showbindViewAnimation];
                            }
                        } else {
                            //失败
                            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
                        }
                    }];
                    
                } else {//绑定了其他路由器
                    NSLog(@"路由器d大大大大于0台");
                    //查看当前路由器是不是被绑定了
                    [[HWFService defaultService]loadBindUserWithUser:[HWFUser defaultUser] MAC:mac completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                        if (code == CODE_SUCCESS) {
                             NSLog(@"++++++++++++++%@",data);
                            if ([[[data objectForKey:@"data"]objectForKey:@"is_bind"]boolValue]) {
                                //被别人绑定了，跳到首页
                                NSString *username = [[data objectForKey:@"userinfo"]objectForKey:@"username"];
                                [self showTipWithType:HWFTipTypeWarning code:CODE(data) message:[NSString stringWithFormat:@"被%@用户绑定",username]];
                                [self dismissViewControllerAnimated:YES completion:^{
                                }];
                                
                            } else {
                                //没被绑定
                                 [self doBind];
//                                [self showbindViewAnimation];
                            }
                        } else {
                            //失败
                            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
                        }
                    }];
                }
            }];
            
        } else {
                //判断是不是极路由环境
                NSArray *macArray = [HIWIFI_MAC_PREFIX componentsSeparatedByString:@"|"];
                NSString *mac = [HWFTool MAC4ConnectedWiFi];
                NSLog(@"==========%@",mac);//D4EE070AC74A
                if ((mac && [[mac substringWithRange:NSMakeRange(0, 6)] isEqualToString:macArray[0]]) || (mac && [[mac substringWithRange:NSMakeRange(0, 6)] isEqualToString:macArray[1]])) {
                    HWFLoginFaiedlViewController *loginFailedVC = [[HWFLoginFaiedlViewController alloc]initWithNibName:@"HWFLoginFaiedlViewController" bundle:nil];
                    [self.navigationController pushViewController:loginFailedVC animated:YES];
                } else {
                    [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
                }
        }
    }];
}


#pragma mark - 手机注册
- (IBAction)mobileRegisterAction:(UIButton *)sender {
    HWFMobileRegisterViewController *mobileRegisterVC = [[HWFMobileRegisterViewController alloc]initWithNibName:@"HWFMobileRegisterViewController" bundle:nil];
    mobileRegisterVC.mobileOrPwdIdentify = @"mobile";
    [self.navigationController pushViewController:mobileRegisterVC animated:YES];
}

#pragma mark - 找回密码
- (IBAction)seekPwdAction:(UIButton *)sender {
    HWFMobileRegisterViewController *mobileRegisterVC = [[HWFMobileRegisterViewController alloc]initWithNibName:@"HWFMobileRegisterViewController" bundle:nil];
    mobileRegisterVC.mobileOrPwdIdentify = @"password";
    [self.navigationController pushViewController:mobileRegisterVC animated:YES];
}

#pragma mark - 描述路由器能做什么
- (IBAction)describeAction:(UIButton *)sender {
    DDLogDebug(@"描述路由器能做什么");
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!_isBeingUp) {
        [self upwardsElements];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    switch (textField.tag) {
        case 100:
            [self.passwordTextField becomeFirstResponder];
            break;
        case 101:
            [self doLogin:nil];
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - 连接失败遮罩
- (IBAction)connectFailedMaskAction:(UIButton *)sender {
    [self hidenConnectFailedViewAnimation];
}

#pragma mark - 连接失败 - ui
- (void)hidenConnectFailedViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"connectFailedTopCons"]) {
            tempCons.constant = -470;
        }
    }
    [self.connectFailedMaskButton setHidden:YES];
    [UIView animateWithDuration:0.3f animations:^{
        self.connectedFailedBgView.top = -470;
    } completion:^(BOOL finished) {
    }];
}

- (void)showConnectFailedViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"connectFailedTopCons"]) {
            tempCons.constant = (self.view.bounds.size.height-470)/2;
        }
    }
    [self.connectFailedMaskButton setHidden:NO];
    [UIView animateWithDuration:0.3f animations:^{
        self.connectedFailedBgView.top = (self.view.bounds.size.height-470)/2;
    } completion:^(BOOL finished) {
    }];
}

//#pragma mark - 绑定遮罩
//- (IBAction)bindMaskAction:(UIButton *)sender {
//    [self hidenbindViewAnimation];
//}
//
//#pragma mark - 立即绑定 - ui
//- (void)hidenbindViewAnimation {
//    NSArray *ary = self.view.constraints;
//    for(NSLayoutConstraint *tempCons in ary) {
//        if([tempCons.identifier isEqualToString: @"bindTopCons"]) {
//            tempCons.constant = -470;
//        }
//    }
//    [self.bindMaskButton setHidden:YES];
//    [UIView animateWithDuration:0.3f animations:^{
//        self.bindBgView.top = -470;
//    } completion:^(BOOL finished) {
//    }];
//}
//
//- (void)showbindViewAnimation {
//    NSArray *ary = self.view.constraints;
//    for(NSLayoutConstraint *tempCons in ary) {
//        if([tempCons.identifier isEqualToString: @"bindTopCons"]) {
//            NSLog(@"===============test");
//            tempCons.constant = (self.view.bounds.size.height-470)/2;
//        }
//    }
//    [self.bindMaskButton setHidden:NO];
//    [UIView animateWithDuration:0.3f animations:^{
//        NSLog(@"========22=======test");
//        self.bindBgView.top = (self.view.bounds.size.height-470)/2;
//    } completion:^(BOOL finished) {
//    }];
//}


#pragma mark - connectFailed
- (IBAction)connectedButtonAction:(UIButton *)sender {
    [self hidenConnectFailedViewAnimation];
    NSArray *macArray = [HIWIFI_MAC_PREFIX componentsSeparatedByString:@"|"];
    NSString *mac = [HWFTool MAC4ConnectedWiFi];
    if ((mac && [[mac substringWithRange:NSMakeRange(0, 6)] isEqualToString:macArray[0]]) || (mac && [[mac substringWithRange:NSMakeRange(0, 6)] isEqualToString:macArray[1]])) {
        [self loadingViewShow];
        [[HWFService defaultService]loadBindUserWithUser:[HWFUser defaultUser] MAC:mac completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            if (code == CODE_SUCCESS) {
                NSLog(@"++++++++++++++%@",data);
                if ([[[data objectForKey:@"data"]objectForKey:@"is_bind"]boolValue]) {
                    //被绑定了
                    [self showConnectFailedViewAnimation];
                    NSString *username = [[data objectForKey:@"userinfo"]objectForKey:@"username"];
                    [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:[NSString stringWithFormat:@"被%@用户绑定",username]];
                    
                } else {
                    //没被绑定
                    [self doBind];
//                    [self showbindViewAnimation];
                }
            } else {
                //失败
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];
        
    } else {
        [self showTipWithType:HWFTipTypeFailure code:CODE_NIL message:@"当前环境不在极路由环境下"];
    }
}

#pragma mark - 退出登录
- (IBAction)logoutAction:(UIButton *)sender {
    [self loadingViewShow];
    [[HWFService defaultService] logoutCompletion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            [self hidenConnectFailedViewAnimation];
//            self.userNameTextField.text = @"";
//            self.passwordTextField.text = nil;
        }else{
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - 绑定
//- (IBAction)bindAction:(UIButton *)sender {
////    [self hidenbindViewAnimation];
//    
//}
- (void)doBind {
    HWFBindWebViewController *bindWebVC = [[HWFBindWebViewController alloc]initWithNibName:@"HWFBindWebViewController" bundle:nil];
    bindWebVC.HTTPMethod = HTTPMethodPost;
    NSString *str = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_WEB_ROUTER_BIND];
    NSString *url = [NSString stringWithFormat:@"%@&token=%@",str,[HWFUser defaultUser].uToken];
    bindWebVC.URL = url;
    bindWebVC.delegate = self;
    [self.navigationController pushViewController:bindWebVC animated:YES];
}

#pragma mark - HWFBindWebViewControllerDelegate
- (void)bindRouterSuccessCallbackWithMAC:(NSString *)aMAC {
    [self showTipWithType:HWFTipTypeSuccess code:CODE_SUCCESS message:@"绑定成功"];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)bindRouterBySelfCallback {
//    [self showbindViewAnimation];
    [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"路由器已被自己绑定"];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
