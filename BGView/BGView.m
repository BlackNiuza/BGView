//
//  BGView.m
//
//  Created by blackniuza on 13-3-11.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import "BGView.h"
#import <QuartzCore/QuartzCore.h>

#define kBackGestureCommitLength 100
#define kBackGestureNeedAdjustAlpha 0.7
#define kBackGestureNeedAdjustDx 6


@implementation BGView

@synthesize backGestureDelegate;
@synthesize preViewImage;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initBGView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initBGView];
    }
    return self;
}

-(void)initBGView
{
    [self addBackGesture];
}


#pragma mark - Public Methods
-(void)addBackGesture
{
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(backGestureRecognized:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

-(void)setPreViewImage:(UIImage *)pPreViewImage
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgView.image = pPreViewImage;
    _preView = imgView;
}

#pragma mark - Private Methods
-(void)backGestureRecognized:(UIPanGestureRecognizer*)recognizer
{
    if(_preView==nil) return;
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        [self endEditing:YES];
        [self setLayout];
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan
        || recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer translationInView:self];
        if(point.x>0){
            [self setViewPosition:point];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        LOG_GRAPHICS(2,@"_currView.frame.origin.x = %f",_currView.frame.origin.x);
        if(_currView.frame.origin.x > kBackGestureCommitLength){
            //触发
            [self moveOutSelfWithAnimation:YES];
        }else{
            //未触发
            [self resetStateWithAnimation:YES];
        }
    }
}

-(void)setLayout
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(size,YES, 0.0);
    [self.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgView.image = image;
    _currView = imgView;
    
    UIView *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *background = [[UIView alloc] initWithFrame:window.bounds];
    background.backgroundColor = [UIColor blackColor];
    _backgroundView = background;
    
    UIView *shadow = [[UIView alloc] initWithFrame:window.bounds];
    shadow.backgroundColor = [UIColor blackColor];
    _shadowView = shadow;
    
    [window addSubview:background];
    [background addSubview:_preView];
    [background addSubview:shadow];
    [background addSubview:_currView];

}

-(void)setViewPosition:(CGPoint)point
{
    _currView.frame = CGRectOffset(_currView.bounds, point.x, 0);
    
    float proportion = [[UIScreen mainScreen] bounds].size.width - _currView.frame.origin.x;
    float ratio = proportion / ([[UIScreen mainScreen] bounds].size.width);
    float alpha = kBackGestureNeedAdjustAlpha * ratio;
    if(_shadowView != nil){
        _shadowView.alpha = alpha;
    }
}

-(void)moveOutSelfWithAnimation:(BOOL)animation
{
    BOOL shouldPop = YES;
    if(self.backGestureDelegate && [self.backGestureDelegate respondsToSelector:@selector(shouldPopViewController:)])
    {
        shouldPop = [self.backGestureDelegate shouldPopViewController:self];
    }
    if(shouldPop){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _currView.frame;
            frame.origin.x = frame.size.width;
            _currView.frame = frame;
            _shadowView.alpha = 0;
        } completion:^(BOOL finished) {
            //移除底图
            [_backgroundView removeFromSuperview];
        }];
    }else{
        [self resetStateWithAnimation:YES];
    }

}

-(void)resetStateWithAnimation:(BOOL)animation
{
    [UIView animateWithDuration:0.3 animations:^{
        _currView.frame = _currView.bounds;
        _shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        //移除底图
        [_backgroundView removeFromSuperview];
    }];
}

@end
