//
//  HWFDownloadTaskAddViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDownloadTaskAddViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <ZBarSDK.h>

#import "HWFService+Download.h"

@interface HWFDownloadTaskAddViewController () <ZBarReaderDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextView *downloadURLTextView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@property (strong, nonatomic) ZBarReaderViewController *QRScannerViewController;

@end

@implementation HWFDownloadTaskAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // View
    self.title = @"新建下载任务";
    [self addBackBarButtonItem];
    [self addRightBarButtonItemWithImage:nil activeImage:nil title:@"扫一扫" target:self action:@selector(addDownloadTaskWithScan:)];
    
    [self.downloadButton setBackgroundImage:[[UIImage imageNamed:@"btn-4"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateNormal];
    [self.downloadButton setBackgroundImage:[[UIImage imageNamed:@"btn-1"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateHighlighted];
    
    // TextView
    self.downloadURLTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadButtonClick:(id)sender {
    [self.downloadURLTextView resignFirstResponder];
    
    NSString *URL = self.downloadURLTextView.text;
    if (!URL || IS_STRING_EMPTY(URL)) {
        [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"请输入下载地址"];
        return;
    }
    
    UIActionSheet *partitionsActionSheet = [[UIActionSheet alloc] initWithTitle:@"请您选择下载分区" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (HWFPartition *partition in self.partitions) {
        [partitionsActionSheet addButtonWithTitle:partition.displayName];
    }
    [partitionsActionSheet addButtonWithTitle:@"取消"];
    partitionsActionSheet.cancelButtonIndex = self.partitions.count;
    [partitionsActionSheet showInView:self.view];
}

- (void)addDownloadTaskWithPartition:(HWFPartition *)aPartition {
    NSString *URL = self.downloadURLTextView.text;
    if (!URL || IS_STRING_EMPTY(URL)) {
        [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"请输入下载地址"];
        return;
    }
    
    [[HWFService defaultService] addDownloadTaskWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] partition:aPartition URLs:@[ URL ] forceReDownload:YES completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        
        if (CODE_SUCCESS == code) {
            //TODO: 文案
            [self showTipWithType:HWFTipTypeSuccess code:code message:@"资源添加成功，即将开始下载"];
            if ([self.delegate respondsToSelector:@selector(addTaskWithDownloadTaskAddViewController:)]) {
                [self.delegate addTaskWithDownloadTaskAddViewController:self];
            }
            self.downloadURLTextView.text = nil;
        } else {
            //TODO: 错误提示
            [self showTipWithType:HWFTipTypeFailure code:code message:msg];
        }
        
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < self.partitions.count) {
        HWFPartition *partition = self.partitions[buttonIndex];
        [self addDownloadTaskWithPartition:partition];
    }
}

#pragma mark - 收回键盘
- (IBAction)maskButtonClick:(UIButton *)sender {
    [self.downloadURLTextView resignFirstResponder];
}

#pragma mark - 扫一扫
- (void)addDownloadTaskWithScan:(id)sender {
    self.QRScannerViewController = [ZBarReaderViewController new];
    
    self.QRScannerViewController.readerDelegate = self;
    self.QRScannerViewController.wantsFullScreenLayout = NO; // 非全屏
    self.QRScannerViewController.showsZBarControls = NO; // 隐藏底部控制按钮
    self.QRScannerViewController.readerView.torchMode = 0; // 关闭闪光灯
    [self setOverlayPickerView:self.QRScannerViewController]; // 自定义界面
    
    ZBarImageScanner *scanner = self.QRScannerViewController.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    // Navigation Bar
    self.QRScannerViewController.title = @"扫一扫";
    
    UIButton *leftBarButton = [[UIButton alloc] init];
    [leftBarButton setFrame:CGRectMake(0, 0, 22, 22)];
    [leftBarButton setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:@"arrow-left-blue"] forState:UIControlStateHighlighted];
    [leftBarButton setTitle:nil forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(dismissQRScanner:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    self.QRScannerViewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [self.navigationController pushViewController:self.QRScannerViewController animated:YES];
}

- (void)setOverlayPickerView:(ZBarReaderViewController *)reader {
    UIView *QRScannerView = [[[NSBundle mainBundle] loadNibNamed:@"HWFQRScannerView" owner:self options:nil] firstObject];
    [reader.view addSubview:QRScannerView];
}

- (void)dismissQRScanner:(id)sender {
    [self.QRScannerViewController.navigationController popViewControllerAnimated:YES];
}

- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry {
    DDLogDebug(@"QR Scan failed!");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    
    ZBarSymbol * symbol;
    for(symbol in results) {
        break;
    }
    
    NSString *symbolString = symbol.data;
    
    // 中文乱码转换
    if ([symbolString canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
        symbolString = [NSString stringWithCString:[symbolString cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    
    DDLogDebug(@"QR: %@", symbolString);
//    [self addDownloadTaskWithURL:symbolString];
    self.downloadURLTextView.text = symbolString;
    [self dismissQRScanner:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    DDLogDebug(@"Cancel");
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
