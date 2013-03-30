//
//  BGViewBackGestureDelegate.h
//  weitao
//
//  Created by blackniuza on 13-3-11.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BGViewBackGestureDelegate <NSObject>
@optional
-(BOOL)shouldPopViewController:(UIView*)view ;

@end
