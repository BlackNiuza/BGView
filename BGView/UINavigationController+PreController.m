//
//  UINavigationController+PreController.m
//  weitao
//
//  Created by blackniuza on 13-3-11.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import "UINavigationController+PreController.h"

@implementation UINavigationController (PreController)

-(UIViewController*)preController
{
    NSInteger count = [self.viewControllers count];
    if(count<=1) return nil;
    return [self.viewControllers objectAtIndex:count-2];
}

@end
