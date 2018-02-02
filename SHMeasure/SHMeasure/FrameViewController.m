//
//  FrameViewController.m
//  SHMeasure
//
//  Created by lvshaohua on 2018/2/2.
//  Copyright © 2018年 lvshaohua. All rights reserved.
//

#import "FrameViewController.h"
#import "ZDStickerView.h"

@interface FrameViewController () <ZDStickerViewDelegate>
@property (weak, nonatomic) IBOutlet ZDStickerView *stickerView;
@property (weak, nonatomic) IBOutlet UILabel *XLabel;
@property (weak, nonatomic) IBOutlet UILabel *YLabel;
@property (weak, nonatomic) IBOutlet UILabel *widthLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation FrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIView* contentView = [[UIView alloc] initWithFrame:self.stickerView.bounds];
    [contentView setBackgroundColor:[UIColor blackColor]];
    
    self.stickerView.tag = 0;
    self.stickerView.stickerViewDelegate = self;
//    self.stickerView.contentView = contentView;//contentView;
    self.stickerView.backgroundColor = [UIColor blackColor];
    self.stickerView.preventsPositionOutsideSuperview = NO;
    self.stickerView.translucencySticker = NO;
    [self.stickerView showEditingHandles];
    
    [self.switchButton setOn:[[NSUserDefaults standardUserDefaults]boolForKey:@"switch"]];
    self.stickerView.isSwitchOn = self.switchButton.isOn;
    
    NSInteger red = [[NSUserDefaults standardUserDefaults] integerForKey:@"red"];
    NSInteger green = [[NSUserDefaults standardUserDefaults] integerForKey:@"green"];
    NSInteger blue = [[NSUserDefaults standardUserDefaults] integerForKey:@"blue"];
    CGFloat alpha = [[NSUserDefaults standardUserDefaults] floatForKey:@"alpha"];
    
    UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 1.0];
    self.stickerView.backgroundColor = color;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)stickerViewDidMoved:(ZDStickerView *)sticker {
    self.XLabel.text = [NSString stringWithFormat:@"%d", (int)(CGRectGetMinX(sticker.frame) * 2)];
    self.YLabel.text = [NSString stringWithFormat:@"%d", (int)(CGRectGetMinY(sticker.frame) * 2)];
    self.widthLabel.text = [NSString stringWithFormat:@"%d", (int)(sticker.frame.size.width * 2)];
    self.heightLabel.text = [NSString stringWithFormat:@"%d", (int)(sticker.frame.size.height * 2)];
}

- (IBAction)switchButton:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"switch"];
    self.stickerView.isSwitchOn = sender.isOn;
}
- (IBAction)doBackAction:(UIButton *)sender {
     [self.navigationController popViewControllerAnimated:YES];
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
