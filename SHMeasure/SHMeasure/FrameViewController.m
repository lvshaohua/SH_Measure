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
@property (weak, nonatomic) IBOutlet UIView *cornerView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic) CGPoint prevPoint;

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
    
    [self.switchButton setOn:[[NSUserDefaults standardUserDefaults]boolForKey:@"switch"]];
    
    NSInteger red = [[NSUserDefaults standardUserDefaults] integerForKey:@"red"];
    NSInteger green = [[NSUserDefaults standardUserDefaults] integerForKey:@"green"];
    NSInteger blue = [[NSUserDefaults standardUserDefaults] integerForKey:@"blue"];
    CGFloat alpha = [[NSUserDefaults standardUserDefaults] floatForKey:@"alpha"];
    
    UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 1.0];
    self.stickerView.backgroundColor = color;
    
    UIPanGestureRecognizer*cornerPanResizeGesture = [[UIPanGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(resizeTranslate:)];
    [self.cornerView addGestureRecognizer:cornerPanResizeGesture];
    
    UIPanGestureRecognizer*rightPanResizeGesture = [[UIPanGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(rightResizeTranslate:)];
    [self.rightView addGestureRecognizer:rightPanResizeGesture];
    UIPanGestureRecognizer*bottomPanResizeGesture = [[UIPanGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(bottomresizeTranslate:)];
    [self.bottomView addGestureRecognizer:bottomPanResizeGesture];
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
    [self resetStickerViewFrame:sticker.frame];
}

- (IBAction)switchButton:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"switch"];
}
- (IBAction)doBackAction:(UIButton *)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        self.prevPoint = [recognizer locationInView:self.view];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [recognizer locationInView:self.view];
        float wChange = 0.0, hChange = 0.0;
        
        wChange = (point.x - self.prevPoint.x);
        hChange = point.y - self.prevPoint.y;
        if (self.switchButton.isOn) {
            self.stickerView.frame = CGRectMake(self.stickerView.frame.origin.x - wChange,
                                    self.stickerView.frame.origin.y - hChange,
                                    self.stickerView.frame.size.width + (wChange * 2),
                                    self.stickerView.frame.size.height + (hChange * 2));
            
            
            
        } else {
            
            self.stickerView.frame = CGRectMake(self.stickerView.frame.origin.x,
                                    self.stickerView.frame.origin.y,
                                    self.stickerView.frame.size.width + (wChange ),
                                    self.stickerView.frame.size.height + (hChange));
            
        }
        [self resetStickerViewFrame:self.stickerView.frame];
        self.prevPoint = [recognizer locationOfTouch:0 inView:self.view];
    }
}

- (void)rightResizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        self.prevPoint = [recognizer locationInView:self.view];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [recognizer locationInView:self.view];
        float wChange = 0.0, hChange = 0.0;
        
        wChange = (point.x - self.prevPoint.x);
        hChange = 0;
        if (self.switchButton.isOn) {
            self.stickerView.frame = CGRectMake(self.stickerView.frame.origin.x - wChange,
                                                self.stickerView.frame.origin.y - hChange,
                                                self.stickerView.frame.size.width + (wChange * 2),
                                                self.stickerView.frame.size.height);
            
        } else {
            
            self.stickerView.frame = CGRectMake(self.stickerView.frame.origin.x,
                                                self.stickerView.frame.origin.y,
                                                self.stickerView.frame.size.width + (wChange ),
                                                self.stickerView.frame.size.height);
            
        }
        [self resetStickerViewFrame:self.stickerView.frame];
        self.prevPoint = [recognizer locationOfTouch:0 inView:self.view];
    }
}

- (void)bottomresizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        self.prevPoint = [recognizer locationInView:self.view];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [recognizer locationInView:self.view];
        float wChange = 0.0, hChange = 0.0;
        
        wChange = 0;
        hChange = point.y - self.prevPoint.y;
        if (self.switchButton.isOn) {
            self.stickerView.frame = CGRectMake(self.stickerView.frame.origin.x - wChange,
                                                self.stickerView.frame.origin.y - hChange,
                                                self.stickerView.frame.size.width,
                                                self.stickerView.frame.size.height + (hChange * 2));
            
        } else {
            
            self.stickerView.frame = CGRectMake(self.stickerView.frame.origin.x,
                                                self.stickerView.frame.origin.y,
                                                self.stickerView.frame.size.width,
                                                self.stickerView.frame.size.height + (hChange));
            
        }
        [self resetStickerViewFrame:self.stickerView.frame];
        self.prevPoint = [recognizer locationOfTouch:0 inView:self.view];
    }
}

- (void)resetStickerViewFrame:(CGRect)frame {
    
    
    self.cornerView.frame = CGRectMake(self.stickerView.frame.origin.x + self.stickerView.frame.size.width - 18,
                                       self.stickerView.frame.origin.y + self.stickerView.frame.size.height - 18,
                                       self.cornerView.frame.size.width,
                                       self.cornerView.frame.size.height);
    
    self.rightView.frame = CGRectMake(self.stickerView.frame.origin.x + self.stickerView.frame.size.width - 18,
                                      self.stickerView.frame.origin.y,
                                      self.rightView.frame.size.width,
                                      self.stickerView.frame.size.height);
    
    self.bottomView.frame = CGRectMake(self.stickerView.frame.origin.x,
                                       self.stickerView.frame.origin.y + self.stickerView.frame.size.height - 18,
                                       self.stickerView.frame.size.width,
                                       self.bottomView.frame.size.height);
    
    self.XLabel.text = [NSString stringWithFormat:@"%d", (int)(CGRectGetMinX(frame) * 2)];
    self.YLabel.text = [NSString stringWithFormat:@"%d", (int)(CGRectGetMinY(frame) * 2)];
    self.widthLabel.text = [NSString stringWithFormat:@"%d", (int)(frame.size.width * 2)];
    self.heightLabel.text = [NSString stringWithFormat:@"%d", (int)(frame.size.height * 2)];
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
