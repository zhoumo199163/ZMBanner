# ZMBanner
轮播图
支持本地及网络图下载和缓存，图片下载使用SDWebImage  
支持图片点击事件  
集成代码：  
```
/**
 *  初始化Banner
 *
 *  @param frame                轮播图的Frame
 *  @param point                pagePoint:点的位置
 *  @param imageArray           图片数组，支持本地图片或地址
 *  @param time                 滚动间隔时间
 *  @param placeholderImageName 默认图片名称
 *
 *  @return
 */
 
ZMBannerView *zmBanner = [[ZMBannerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)   pageControlPoint:CGPointMake(screenWidth/2, screenHeight - 50)  
imageArray:imageArray scrollTimeInterval:5.0f placeholderImageName:@"placeholder.JPG"];  
```
效果图：  
![image](https://github.com/zhoumo199163/ZMBanner/blob/master/banner.gif)


