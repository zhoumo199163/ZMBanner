//
//  ZMBannerView.h
//  Demo
//
//  Created by zm on 16/4/15.
//  Copyright © 2016年 zm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZMBannerView;
@protocol ZMBannerDelegate <NSObject>

/**
 *  点击图片事件
 *
 *  @param imagePage
 */
- (void)clickedImagePage:(NSInteger)imagePage;

@end

@interface ZMBannerView : UIView

@property (nonatomic, assign) id<ZMBannerDelegate> bannerDelegate;

- (instancetype)initWithFrame:(CGRect)frame pageControlPoint:(CGPoint)point imageArray:(NSArray *)imageArray scrollTimeInterval:(CGFloat)time;

@end
