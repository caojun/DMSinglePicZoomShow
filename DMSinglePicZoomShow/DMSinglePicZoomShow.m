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

#import "DMSinglePicZoomShow.h"
#import "UIImageView+WebCache.h"


#if DEBUG
#define DMSinglePicDebug(...)   NSLog(__VA_ARGS__)
#else
#define DMSinglePicDebug(...)
#endif

@interface DMSinglePicZoomShow () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *m_scrollView;
@property (nonatomic, strong) UIImageView *m_imageView;
@property (nonatomic, weak) UITapGestureRecognizer *m_tap;
@property (nonatomic, weak) UITapGestureRecognizer *m_doubleTap;
@property (nonatomic, weak) UILongPressGestureRecognizer *m_longPress;

@end

@implementation DMSinglePicZoomShow

#pragma mark - Life Cycle

- (void)dealloc
{
    DMSinglePicDebug(@"%@ dealloc", [[self class] description]);
    
    [self.m_imageView sd_cancelCurrentImageLoad];
}

+ (instancetype)singlePicZoomShowWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    return [[self alloc] initWithFrame:frame andImage:image];
}

+ (instancetype)singlePicZoomShowWithFrame:(CGRect)frame andUrlString:(NSString *)urlString
{
    return [[self alloc] initWithFrame:frame andUrlString:urlString];
}

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.image = image;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andUrlString:(NSString *)urlString
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.imageUrlString = urlString;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (void)defaultSetting
{
    [self createScrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (![self.subviews containsObject:self.m_scrollView])
    {
        [self addSubview:self.m_scrollView];
    }

    self.m_scrollView.frame = self.bounds;
    self.m_scrollView.contentSize = self.bounds.size;
    self.m_imageView.frame = self.bounds;
}

#pragma mark - Sub Views
#pragma mark ScrollView
- (void)createScrollView
{
    if (nil == self.m_scrollView)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        self.m_scrollView = scrollView;
        
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;

        [self createImageView];
    }
}

#pragma mark ImageView
- (void)createImageView
{
    if (nil == self.m_imageView)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.m_scrollView addSubview:imageView];
        self.m_imageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = self.image;
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.m_imageView;
}

- (void)scrollZoomHandle:(UIScrollView *)scrollView
{
    CGFloat x = 0;
    CGFloat y = 0;
    if (self.m_imageView.frame.size.width < scrollView.frame.size.width
        || self.m_imageView.frame.size.height < scrollView.frame.size.height)
    {
        x = (scrollView.frame.size.width - scrollView.contentSize.width) / 2;
        y = (scrollView.frame.size.height - scrollView.contentSize.height) / 2;
    }
    
    self.m_imageView.frame = (CGRect){x, y, self.m_imageView.frame.size};
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self scrollZoomHandle:scrollView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self scrollZoomHandle:scrollView];
}

#pragma mark - setter / getter
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.m_imageView.image = image;
    [self setNeedsLayout];
}

- (void)setImageUrlString:(NSString *)imageUrlString
{
    _imageUrlString = [imageUrlString copy];
    
    NSURL *imageUrl = [NSURL URLWithString:_imageUrlString];
    [self.m_imageView sd_setImageWithURL:imageUrl placeholderImage:self.placeholderImage];
}

- (CGFloat)maxScale
{
    return self.m_scrollView.maximumZoomScale;
}

- (void)setMaxScale:(CGFloat)maxScale
{
    NSLog(@"self.m_scrollView.maximumZoomScale = %f", self.m_scrollView.maximumZoomScale);
    
    self.m_scrollView.maximumZoomScale = maxScale;
}

- (CGFloat)minScale
{
    return self.m_scrollView.minimumZoomScale;
}

- (void)setMinScale:(CGFloat)minScale
{
    self.m_scrollView.minimumZoomScale = minScale;
}

- (void)setCurScale:(CGFloat)curScale
{
    [self setCurScale:curScale animated:NO];
}

- (void)setCurScale:(CGFloat)curScale animated:(BOOL)animated
{
    [self.m_scrollView setZoomScale:curScale animated:animated];
}

- (void)setLongPressEnable:(BOOL)longPressEnable
{
    _longPressEnable = longPressEnable;
    
    if (longPressEnable)
    {
        if (nil == self.m_longPress)
        {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandle:)];
            [self.m_scrollView addGestureRecognizer:longPress];
            self.m_longPress = longPress;
        }
    }
    else
    {
        [self removeGestureRecognizer:self.m_longPress];
        self.m_longPress = nil;
    }
}

- (void)setClickEnable:(BOOL)clickEnable
{
    _clickEnable = clickEnable;
    
    if (clickEnable)
    {
        if (nil == self.m_tap)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [self.m_scrollView addGestureRecognizer:tap];
            self.m_tap = tap;
        }
    }
    else
    {
        [self removeGestureRecognizer:self.m_tap];
        self.m_tap = nil;
    }
}

- (void)setDoubleClickEnable:(BOOL)doubleClickEnable
{
    _doubleClickEnable = doubleClickEnable;
    
    if (doubleClickEnable)
    {
        if (nil == self.m_doubleTap)
        {
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandle:)];
            doubleTap.numberOfTapsRequired = 2;
            doubleTap.numberOfTouchesRequired = 1;
            [self.m_scrollView addGestureRecognizer:doubleTap];
            self.m_doubleTap = doubleTap;
            
            //这句非常 重要，
            [self.m_tap requireGestureRecognizerToFail:doubleTap];
        }
    }
    else
    {
        [self removeGestureRecognizer:self.m_doubleTap];
        self.m_doubleTap = nil;
    }
}

#pragma mark - GestureRecognizer
- (void)longPressHandle:(UILongPressGestureRecognizer *)longPress
{
    if (self.longPressEnable)
    {
        if ([self.delegate respondsToSelector:@selector(singlePicZoomShowLongPress:status:)])
        {
            [self.delegate singlePicZoomShowLongPress:self status:longPress.state];
        }
    }
}

- (void)tapHandle:(UITapGestureRecognizer *)tap
{
    if (self.clickEnable)
    {
        if ([self.delegate respondsToSelector:@selector(singlePicZoomShowTap:status:)])
        {
            [self.delegate singlePicZoomShowTap:self status:tap.state];
        }
    }
}

- (void)doubleTapHandle:(UITapGestureRecognizer *)tap
{
    if (self.doubleClickEnable)
    {
        if ([self.delegate respondsToSelector:@selector(singlePicZoomShowDoubleTap:status:zoomScale:)])
        {
            [self.delegate singlePicZoomShowDoubleTap:self status:tap.state zoomScale:self.m_scrollView.zoomScale];
        }
    }
}


@end
