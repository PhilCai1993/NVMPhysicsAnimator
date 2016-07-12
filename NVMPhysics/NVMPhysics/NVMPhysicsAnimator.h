//
//  NVMPhysicsAnimator.h
//  eleme
//
//  Created by PhilCai on 7/12/16.
//  Copyright © 2016 Rajax Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NVMPhysicsAnimator : NSObject

- (instancetype)init;
- (instancetype)initWithFrictionRatio:(CGFloat)fr springRatio:(CGFloat)sr;

@property (nonatomic, assign, readonly) CGFloat frictionRatio;
@property (nonatomic, assign, readonly) CGFloat springRatio;
@property (nonatomic, assign, readonly) CGPoint currentVelocity;

@property (nonatomic, copy) void (^refreshHandler)(CGPoint currentPosition, CGPoint currentVelocity);

- (void)fireWithVelocity:(CGPoint)velocity from:(CGPoint)from;
- (void)stop;

@end
