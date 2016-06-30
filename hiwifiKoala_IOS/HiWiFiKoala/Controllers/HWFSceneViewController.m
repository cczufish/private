//
//  HWFSceneViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-18.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFSceneViewController.h"

#import "HWFButton.h"

@interface HWFSceneViewController ()

@property (weak, nonatomic) IBOutlet HWFButton *customButton;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation HWFSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
//    self.customButton.title = @"空心字";
    self.customButton.titleFont = [UIFont systemFontOfSize:14.0];
    self.customButton.scaleFactor = CGVectorMake(20, 20);
    self.customButton.tintColor = [UIColor whiteColor];
    self.customButton.clickHandler = ^(HWFButton *sender) {
        NSMutableAttributedString *testLabelText = [[NSMutableAttributedString alloc] initWithString:self.testLabel.text attributes:@{ NSStrokeWidthAttributeName : @3, NSStrokeColorAttributeName : self.testLabel.textColor }];
        self.testLabel.attributedText = testLabelText;
    };
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
