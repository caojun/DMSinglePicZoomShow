/**
 The MIT License (MIT)
 
 Copyright (c) 2015 DreamCao
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import <UIKit/UIKit.h>

@class DMSinglePicZoomShow;


#pragma mark - DMSinglePicZoomShowDelegate
@protocol DMSinglePicZoomShowDelegate <NSObject>

@optional
/**
 *  点击
 *
 *  @param view
 *  @param status 点击的状态
 */
- (void)singlePicZoomShowTap:(DMSinglePicZoomShow *)view status:(UIGestureRecognizerState)status;

/**
 *  双击
 *
 *  @param view
 *  @param statu 状态
 *  @param scale 缩放比例
 */
- (void)singlePicZoomShowDoubleTap:(DMSinglePicZoomShow *)view status:(UIGestureRecognizerState)status zoomScale:(CGFloat)scale;

/**
 *  长按
 *
 *  @param view
 *  @param status 长按状态
 */
- (void)singlePicZoomShowLongPress:(DMSinglePicZoomShow *)view status:(UIGestureRecognizerState)status;

@end


#pragma mark -

IB_DESIGNABLE
@interface DMSinglePicZoomShow : UIView

/**
 *  最大缩放比例
 */
@property (nonatomic, assign) IBInspectable CGFloat maxScale;

/**
 *  最小缩放比例
 */
@property (nonatomic, assign) IBInspectable CGFloat minScale;

/**
 *  当前缩放值
 */
@property (nonatomic, assign) CGFloat curScale;

/**
 *  图片
 */
@property (nonatomic, strong) IBInspectable UIImage *image;

@property (nonatomic, strong) IBInspectable UIImage *placeholderImage;
@property (nonatomic, copy) IBInspectable NSString *imageUrlString;

/**
 *  开启双击, 默认为 NO
 */
@property (nonatomic, assign) IBInspectable BOOL doubleClickEnable;

/**
 *  开启点击, 默认为 NO
 */
@property (nonatomic, assign) IBInspectable BOOL clickEnable;

/**
 *  开启长按，默认为 NO
 */
@property (nonatomic, assign) IBInspectable BOOL longPressEnable;

/**
 *  代理
 */
@property (nonatomic, weak) IBOutlet id<DMSinglePicZoomShowDelegate> delegate;

+ (instancetype)singlePicZoomShowWithFrame:(CGRect)frame andImage:(UIImage *)image;
+ (instancetype)singlePicZoomShowWithFrame:(CGRect)frame andUrlString:(NSString *)urlString;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;
- (instancetype)initWithFrame:(CGRect)frame andUrlString:(NSString *)urlString;

- (void)setCurScale:(CGFloat)zoomScale animated:(BOOL)animated;

@end
