//
//  ZMBannerImageView.h
//  ZMBanner
//
//  Created by zm on 16/5/4.
//  Copyright © 2016年 zm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMBannerImageView : UIImageView

/**
 *  初始化ImageView
 *
 *  @param imageName   imageName/imageUrl
 *  @param placeholder 默认图片Name
 *
 *  @return 
 */
- (id)initWithImageName:(NSString *)imageName placeholder:(NSString *)placeholder;

@end
