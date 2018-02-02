//
//  ViewController.m
//  SHMeasure
//
//  Created by lvshaohua on 2018/2/2.
//  Copyright © 2018年 lvshaohua. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"alpha"]) {
        [[NSUserDefaults standardUserDefaults]setFloat:1.0 forKey:@"alpha"];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
