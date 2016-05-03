//
//  ViewController.m
//  ZMBanner
//
//  Created by zm on 16/4/20.
//  Copyright © 2016年 zm. All rights reserved.
//

#import "ViewController.h"
#import "ZMBannerView.h"

#define screenHeight [[UIScreen mainScreen]bounds].size.height //屏幕高度
#define screenWidth [[UIScreen mainScreen]bounds].size.width   //屏幕宽度

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *imageArray = @[@"IMG_1.JPG",@"IMG_2.JPG"];
    ZMBannerView *zmBanner = [[ZMBannerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) pageControlPoint:CGPointMake(screenWidth/2, screenHeight - 50) imageArray:imageArray scrollTimeInterval:2.0f];
    [self.view addSubview:zmBanner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
