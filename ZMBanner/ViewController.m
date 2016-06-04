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

@interface ViewController ()<ZMBannerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *imageArray = @[@"http://ww2.sinaimg.cn/wap720/005y9kZzgw1f1lorhlzn1j30vj0hsgn7.jpg",@"IMG_3.JPG",@"IMG_2.JPG"];
    ZMBannerView *zmBanner = [[ZMBannerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) pageControlPoint:CGPointMake(screenWidth/2, screenHeight - 50) imageArray:imageArray scrollTimeInterval:5.0f placeholderImageName:@"placeholder.JPG"];
    zmBanner.bannerDelegate = self;
    [self.view addSubview:zmBanner];
    
}

//zmBanner Delegate
- (void)clickedImagePage:(NSInteger)imagePage{
    switch (imagePage) {
        case 0:
            NSLog(@"点击第一幅");
            break;
        case 1:
            NSLog(@"点击第二幅");
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
