//
//  UIViewController+ScreenShot.m
//
//  Created by blackniuza on 13-3-11.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import "UIViewController+ScreenShot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIViewController (ScreenShot)

-(UIImage*)generateScreenShot
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(size,YES, 0.0);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
