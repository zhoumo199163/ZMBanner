//
//  ZMBannerView.m
//  Demo
//
//  Created by zm on 16/4/15.
//  Copyright © 2016年 zm. All rights reserved.
//

#import "ZMBannerView.h"

@interface ZMBannerView()<UIScrollViewDelegate>
{
    CGFloat selfHeight;
    CGFloat selfWidth;
    NSInteger currentImageNumber;
    NSInteger imageNumber;
    CGFloat scrollTime;
    NSArray *imageNameArray;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *preImageView;//上一个
@property (nonatomic, strong) UIImageView *currentImageView;//当前
@property (nonatomic, strong) UIImageView *nextImageView; //下一个
@end

@implementation ZMBannerView

- (instancetype)initWithFrame:(CGRect)frame pageControlPoint:(CGPoint)point imageArray:(NSArray *)imageArray scrollTimeInterval:(CGFloat)time{
    self = [super initWithFrame:frame];
    if(self){
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

- (void)initScrollViewWithImages:(NSArray *)imageArray{
    if(imageArray.count){
        
        UIImage *currentImage = [UIImage imageNamed:[imageArray firstObject]];
        self.currentImageView = [[UIImageView alloc] initWithImage:currentImage];
        self.currentImageView.frame = CGRectMake(selfWidth, 0, selfWidth, selfHeight);
        self.currentImageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:self.currentImageView];
        currentImageNumber = 0;
        
        UITapGestureRecognizer *tapGesureTecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.currentImageView addGestureRecognizer:tapGesureTecognizer];
        
        if(imageArray.count > 1){
            
            UIImage *preImage =  [UIImage imageNamed:[imageArray lastObject]];
            self.preImageView = [[UIImageView alloc]initWithImage:preImage];
            self.preImageView.frame = CGRectMake(0, 0, selfWidth, selfHeight);
            self.preImageView.userInteractionEnabled = YES;
            [self.scrollView addSubview:self.preImageView];
            
            UIImage *nextImage = [UIImage imageNamed:imageArray[1]];
            self.nextImageView = [[UIImageView alloc] initWithImage:nextImage];
            self.nextImageView.frame = CGRectMake(selfWidth *2, 0, selfWidth, selfHeight);
            self.nextImageView.userInteractionEnabled = YES;
            [self.scrollView addSubview:self.nextImageView];
        }
    }
}

//开启计时
- (void)startTime{

    self.timer = [NSTimer scheduledTimerWithTimeInterval:scrollTime target:self selector:@selector(scrollToNextImage) userInfo:nil repeats:YES];

}

//停止计时
- (void)endTime{
        [self.timer invalidate];
}


- (void)scrollToNextImage{
    NSInteger currentPage = self.pageControl.currentPage;
    [self reloadImage:currentPage];

    CGFloat offSetX = self.scrollView.contentOffset.x;
    offSetX += offSetX;
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    if(offSetX >= selfWidth *2){
         [self.scrollView setContentOffset:CGPointMake(selfWidth, 0) ];
    }

}

- (void)reloadImage:(NSInteger)currentPage{
    NSInteger preIndex;
    NSInteger nextIndex;
    if(currentPage == -1){
        //第一张图向左
        currentPage = imageNumber;
        preIndex = currentPage - 1;
        nextIndex = 1;
    }
    else if(currentPage == imageNumber){
        //最后一张图向右
        currentPage = 1;
        preIndex = imageNumber;
        nextIndex = currentPage + 1;
    }
    else{
        currentPage = currentPage +1;
        nextIndex =(currentPage +1) > imageNumber?1:(currentPage +1);
        preIndex = (currentPage -1) <=0?imageNumber:(currentPage - 1);
    }
    
    [self.currentImageView setImage:[UIImage imageNamed:imageNameArray[currentPage - 1]]];
    [self.preImageView setImage:[UIImage imageNamed:imageNameArray[preIndex - 1]]];
    [self.nextImageView setImage:[UIImage imageNamed:imageNameArray[nextIndex -1]]];
    
    self.pageControl.currentPage = currentPage -1;
    currentImageNumber = currentPage - 1;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    NSLog(@"%@",imageNameArray[currentImageNumber]);
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollX = self.scrollView.contentOffset.x;
    NSInteger currentPage = self.pageControl.currentPage;
    
    if(scrollX == 0){
        currentPage = currentPage -1;
        [self reloadImage:currentPage];
        [self.scrollView setContentOffset:CGPointMake(selfWidth, 0) animated:NO];
    }
    else
        if(scrollX == selfWidth*2){
            currentPage = currentPage +1;
            [self reloadImage:currentPage];
            [self.scrollView setContentOffset:CGPointMake(selfWidth, 0) animated:NO];
        }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endTime];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTime];
}

@end
