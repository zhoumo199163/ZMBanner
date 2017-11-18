//
//  ZMBannerView.m
//  Demo
//
//  Created by zm on 16/4/15.
//  Copyright © 2016年 zm. All rights reserved.
//

#import "ZMBannerView.h"
#import <SDImageCache.h>
#import "ZMBannerImageView.h"

@interface ZMBannerView()<UIScrollViewDelegate>
{
    CGFloat selfHeight;
    CGFloat selfWidth;
    NSInteger currentImageNumber;
    NSInteger imageNumber;
    CGFloat scrollTime;
    NSArray *imageNameArray;
    NSString *placeholder;
    
    CGFloat lastMoveX;
    
    NSInteger preIndex;
    NSInteger nextIndex;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) ZMBannerImageView *preImageView;//上一个
@property (nonatomic, strong) ZMBannerImageView *currentImageView;//当前
@property (nonatomic, strong) ZMBannerImageView *nextImageView; //下一个


@end

@implementation ZMBannerView

- (instancetype)initWithFrame:(CGRect)frame pageControlPoint:(CGPoint)point imageArray:(NSArray *)imageArray scrollTimeInterval:(CGFloat)time placeholderImageName:(NSString *)placeholderImageName{
    self = [super initWithFrame:frame];
    if(self){
        if(imageArray.count == 0){
            NSLog(@"没有需要滚动的图片");
        }
        placeholder = placeholderImageName;
        selfHeight = self.frame.size.height;
        selfWidth = self.frame.size.width;
        scrollTime = time;
        imageNumber = [imageArray count];
        imageNameArray = [NSArray arrayWithArray:imageArray];
        [self initScrollView];
        [self initPageControlWithPoint:point];
        [self initScrollViewWithImages:imageArray];

        if(imageNumber == 1){
            //只有一张图片
            self.pageControl.hidden = YES;
            self.scrollView.scrollEnabled = NO;
        }
        else{
            [self startTime];
        }
    }
    return self;
}


//初始化ScrollView
- (void)initScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, selfWidth,selfHeight)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setContentSize:CGSizeMake(imageNumber ==1?selfWidth:3*selfWidth, 0)];
    [self.scrollView setContentOffset:CGPointMake(selfWidth, 0) animated:NO];
    [self addSubview:self.scrollView];

}

//初始化pageControl
- (void)initPageControlWithPoint:(CGPoint)point{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(point.x ,point.y, 0, 0)];
    self.pageControl.numberOfPages = imageNumber;
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:self.pageControl];
}

- (void)initScrollViewWithImages:(NSArray *)imagesArray{
    if(imagesArray.count){
        self.currentImageView = [[ZMBannerImageView alloc] initWithImageName:[imagesArray firstObject] placeholder:placeholder];
        self.currentImageView.frame = CGRectMake(selfWidth, 0, selfWidth, selfHeight);
        [self.scrollView addSubview:self.currentImageView];
        currentImageNumber = 0;
        
        UITapGestureRecognizer *tapGesureTecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.currentImageView addGestureRecognizer:tapGesureTecognizer];
        
        if(imagesArray.count > 1){
            
            self.preImageView = [[ZMBannerImageView alloc] initWithImageName:[imagesArray lastObject] placeholder:placeholder];
            self.preImageView.frame = CGRectMake(0, 0, selfWidth, selfHeight);
            [self.scrollView addSubview:self.preImageView];
            
            self.nextImageView = [[ZMBannerImageView alloc] initWithImageName:imagesArray[1] placeholder:placeholder];
            self.nextImageView.frame = CGRectMake(selfWidth *2, 0, selfWidth, selfHeight);
            [self.scrollView addSubview:self.nextImageView];
        }
    }
}


//开启计时
- (void)startTime{

    self.timer = [NSTimer scheduledTimerWithTimeInterval:scrollTime target:self selector:@selector(scrollToNextImage) userInfo:nil repeats:YES];

    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];

}

//停止计时
- (void)endTime{
    
    [self.timer invalidate];
    self.timer = nil;
}


- (void)scrollToNextImage{
    CGFloat offSetX = self.scrollView.contentOffset.x;
    offSetX += offSetX;
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    if(offSetX >= selfWidth *2){
         [self.scrollView setContentOffset:CGPointMake(selfWidth, 0) ];
    }

}

- (void)completeHandler{
    CGFloat moveX = self.scrollView.contentOffset.x - self.scrollView.bounds.size.width;
    if (fabs(moveX) >= self.bounds.size.width) {
        
        if (moveX > 0 && self.pageControl.currentPage + 1 < imageNumber) {
            self.pageControl.currentPage++;
        }else if (moveX >0 && self.pageControl.currentPage +1 == imageNumber){
            self.pageControl.currentPage = 0;
        }
        else if (self.pageControl.currentPage >= 1){
            self.pageControl.currentPage--;
        }else if (self.pageControl.currentPage == 0 && moveX < 0)
        {
            self.pageControl.currentPage = imageNumber - 1;
        }
        [self resetImage];
    }
}

- (void)resetImage{
    [self.currentImageView setImage:[self getImageFromCache:imageNameArray[self.pageControl.currentPage]]];
    preIndex = self.pageControl.currentPage - 1;
    if(preIndex <0) preIndex = imageNumber -1;
    [self.preImageView setImage:[self getImageFromCache:imageNameArray[preIndex]]];
    nextIndex = self.pageControl.currentPage+1;
    if(nextIndex >= imageNumber) nextIndex = 0;
    [self.nextImageView setImage:[self getImageFromCache:imageNameArray[nextIndex]]];
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
     
    
}

- (UIImage *)getImageFromCache:(NSString *)cacheKey{
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheKey];
    if(!image){
        image = [UIImage imageNamed:placeholder];
    }
    return image;
}


- (void)handleTap:(UITapGestureRecognizer *)tap{
    NSLog(@"%@",imageNameArray[currentImageNumber]);
    if(self.bannerDelegate && [self.bannerDelegate respondsToSelector:@selector(clickedImagePage:)]){
        [self.bannerDelegate clickedImagePage:currentImageNumber];
    }
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat moveX = scrollView.contentOffset.x - CGRectGetWidth(scrollView.frame);

     if (fabs(lastMoveX) >= self.bounds.size.width) {
         [self resetImage];
         lastMoveX = 0;
         return;
     }
    
     if (fabs(moveX) >= self.bounds.size.width) {
         [self completeHandler];
     }
    
    lastMoveX = moveX;

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endTime];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTime];
}

@end
