//
//  BGView.h
//
//  Created by blackniuza on 13-3-11.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGViewBackGestureDelegate.h"
#import "UIViewController+ScreenShot.h"
#import "UINavigationController+PreController.h"

@interface BGView : UIView
<UIGestureRecognizerDelegate>
{
    UIImageView *_preView;
    UIImageView *_currView;
    UIView *_shadowView;
    UIView *_backgroundView;
}

@property(nonatomic, weak) id<BGViewBackGestureDelegate> backGestureDelegate;
@property(nonatomic, strong) UIImage *preViewImage;

-(void)addBackGesture;

@end
