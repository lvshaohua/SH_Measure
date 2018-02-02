//
//  ColorViewController.m
//  SHMeasure
//
//  Created by lvshaohua on 2018/2/2.
//  Copyright © 2018年 lvshaohua. All rights reserved.
//

#import "ColorViewController.h"

@interface ColorViewController ()
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;

@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UILabel *alphaLabel;
@property (weak, nonatomic) IBOutlet UIView *showView;
@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    

    self.redSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"red"];
    self.greenSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"green"];
    self.blueSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"blue"];
    self.alphaSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"alpha"];
    
    self.redLabel.text = [NSString stringWithFormat:@"%d", (int)self.redSlider.value];
    self.greenLabel.text = [NSString stringWithFormat:@"%d", (int)self.greenSlider.value];
    self.blueLabel.text = [NSString stringWithFormat:@"%d", (int)self.blueSlider.value];
    self.alphaLabel.text = [NSString stringWithFormat:@"%d", (int)self.alphaSlider.value];
    
    UIColor *color = [UIColor colorWithRed:self.redSlider.value / 255.0 green:self.greenSlider.value / 255.0 blue:self.blueSlider.value / 255.0 alpha:self.alphaSlider.value / 1.0];
    self.showView.backgroundColor = color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    if (sender.tag == 1) {
        self.redLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
        [[NSUserDefaults standardUserDefaults] setInteger:(int)sender.value forKey:@"red"];
    } else if (sender.tag == 2) {
        self.greenLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
        [[NSUserDefaults standardUserDefaults] setInteger:(int)sender.value forKey:@"green"];
    } else if (sender.tag == 3) {
        self.blueLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
        [[NSUserDefaults standardUserDefaults] setInteger:(int)sender.value forKey:@"blue"];
    } else if (sender.tag == 4) {
        self.alphaLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
        [[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:@"alpha"];
    }
    
    UIColor *color = [UIColor colorWithRed:self.redSlider.value / 255.0 green:self.greenSlider.value / 255.0 blue:self.blueSlider.value / 255.0 alpha:self.alphaSlider.value / 1.0];
    self.showView.backgroundColor = color;
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)screenEdgeSwipe:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.edges == UIRectEdgeLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
