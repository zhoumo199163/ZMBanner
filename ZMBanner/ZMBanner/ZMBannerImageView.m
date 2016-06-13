//
//  ZMBannerImageView.m
//  ZMBanner
//
//  Created by zm on 16/5/4.
//  Copyright © 2016年 zm. All rights reserved.
//

#import "ZMBannerImageView.h"
#import <UIImageView+WebCache.h>

@implementation ZMBannerImageView

- (id)initWithImageName:(NSString *)imageName placeholder:(NSString *)placeholder{
    self = [super init];
    if(self){
        UIImage *placeholderImage = [UIImage imageNamed:placeholder];
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeScaleAspectFit;
        NSString *name = imageName;
        if(name.length == 0){
            name = placeholder;
        }
        
        if([name hasPrefix:@"https://"] || [name hasPrefix:@"http://"]){
            NSURL *url = [NSURL URLWithString:name];
            [self sd_setImageWithURL:url placeholderImage:placeholderImage];
        }
        else{
            UIImage *currentImage = [UIImage imageNamed:name];
            self.image = currentImage;
            [[SDImageCache sharedImageCache] storeImage:currentImage forKey:name];
        }
        
        self.userInteractionEnabled = YES;
    }
    return self;
}


@end
