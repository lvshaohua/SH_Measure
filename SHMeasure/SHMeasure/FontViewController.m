//
//  FontViewController.m
//  SHMeasure
//
//  Created by lvshaohua on 2018/2/2.
//  Copyright © 2018年 lvshaohua. All rights reserved.
//

#import "FontViewController.h"

@interface FontViewController ()
@property (weak, nonatomic) IBOutlet UITextField *enterTextField;
@property (weak, nonatomic) IBOutlet UILabel *show1Label;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *font1Label;
@property (weak, nonatomic) IBOutlet UISlider *font1Slider;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *widthLabel;
@property (weak, nonatomic) IBOutlet UILabel *fontLabel;
@property (weak, nonatomic) IBOutlet UISlider *fontSlider;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation FontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showLabel.layer.borderWidth = 1;
    self.showLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    NSInteger red = [[NSUserDefaults standardUserDefaults] integerForKey:@"red"];
    NSInteger green = [[NSUserDefaults standardUserDefaults] integerForKey:@"green"];
    NSInteger blue = [[NSUserDefaults standardUserDefaults] integerForKey:@"blue"];
    CGFloat alpha = [[NSUserDefaults standardUserDefaults] floatForKey:@"alpha"];
    
    UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 1.0];
    self.showLabel.textColor = color;
    self.show1Label.textColor = color;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    NSInteger font = (int)sender.value;
    
    if (sender == self.font1Slider) {
        self.show1Label.font = self.switchButton.isOn ? [UIFont boldSystemFontOfSize:font] : [UIFont systemFontOfSize:font];
        self.font1Label.text = [NSString stringWithFormat:@"%d", (int)font];
    } else if (sender == self.fontSlider) {
        self.fontLabel.text = [NSString stringWithFormat:@"%d", (int)font];
        [self setShowLabelFont:font];
    }
}

- (IBAction)textFieldValueChanged:(UITextField *)sender {
    self.showLabel.text = sender.text;
    self.heightLabel.text = [NSString stringWithFormat:@"%dpx",(int)(self.showLabel.frame.size.height * 2)];
    self.widthLabel.text = [NSString stringWithFormat:@"%dpx",(int)(self.showLabel.frame.size.width * 2)];
    self.show1Label.text = sender.text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.enterTextField resignFirstResponder];
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    NSInteger font = (int)self.fontSlider.value;
    self.showLabel.font = sender.isOn ? [UIFont boldSystemFontOfSize:font] : [UIFont systemFontOfSize:font];
    self.heightLabel.text = [NSString stringWithFormat:@"%dpx",(int)(self.showLabel.frame.size.height * 2)];
    self.widthLabel.text = [NSString stringWithFormat:@"%dpx",(int)(self.showLabel.frame.size.width * 2)];
    
    NSInteger font1 = (int)self.font1Slider.value;
    self.show1Label.font = sender.isOn ? [UIFont boldSystemFontOfSize:font1] : [UIFont systemFontOfSize:font1];
}

- (void)setShowLabelFont:(NSInteger)font {
    self.showLabel.font = self.switchButton.isOn ? [UIFont boldSystemFontOfSize:font] : [UIFont systemFontOfSize:font];
    self.heightLabel.text = [NSString stringWithFormat:@"%dpx",(int)(self.showLabel.frame.size.height * 2)];
    self.widthLabel.text = [NSString stringWithFormat:@"%dpx",(int)(self.showLabel.frame.size.width * 2)];
}

- (IBAction)screenPan:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.edges == UIRectEdgeLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
