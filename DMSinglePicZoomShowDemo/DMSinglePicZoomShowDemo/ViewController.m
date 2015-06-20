//
//  ViewController.m
//  DMSinglePicZoomShowDemo
//
//  Created by Dream on 15/6/21.
//  Copyright (c) 2015年 GoSing. All rights reserved.
//

#import "ViewController.h"
#import "DMSinglePicZoomShow.h"

@interface ViewController () <DMSinglePicZoomShowDelegate>
@property (weak, nonatomic) IBOutlet DMSinglePicZoomShow *m_zoomView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - DMSinglePicZoomShowDelegate
/**
 *  点击
 *
 *  @param view
 *  @param status 点击的状态
 */
- (void)singlePicZoomShowTap:(DMSinglePicZoomShow *)view status:(UIGestureRecognizerState)status
{
    NSLog(@"%s", __func__);
}

/**
 *  双击
 *
 *  @param view
 *  @param statu 状态
 *  @param scale 缩放比例
 */
- (void)singlePicZoomShowDoubleTap:(DMSinglePicZoomShow *)view status:(UIGestureRecognizerState)status zoomScale:(CGFloat)scale
{
    NSLog(@"%s", __func__);
}

/**
 *  长按
 *
 *  @param view
 *  @param status 长按状态
 */
- (void)singlePicZoomShowLongPress:(DMSinglePicZoomShow *)view status:(UIGestureRecognizerState)status
{
    NSLog(@"%s", __func__);
}

@end
