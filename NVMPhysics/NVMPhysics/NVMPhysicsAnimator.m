//
//  NVMPhysicsAnimator.m
//  eleme
//
//  Created by PhilCai on 7/12/16.
//  Copyright © 2016 Rajax Network Technology Co., Ltd. All rights reserved.
//

#import "NVMPhysicsAnimator.h"

@interface NVMPhysicsAnimator ()

@property(nonatomic, assign) CGFloat frictionRatio;
@property(nonatomic, assign) CGFloat springRatio;
@property(nonatomic, assign) CGPoint currentVelocity;
@property(nonatomic, assign) CGPoint currentPosition;

@property(nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation NVMPhysicsAnimator

#pragma mark - init

- (instancetype)init {
  return [self initWithFrictionRatio:1 springRatio:1];
}

- (instancetype)initWithFrictionRatio:(CGFloat)fr springRatio:(CGFloat)sr {
  if (self = [super init]) {
    self.frictionRatio = fr;
    self.springRatio = sr;
    self.currentVelocity = CGPointZero;
    self.displayLink =
        [CADisplayLink displayLinkWithTarget:self
                                    selector:@selector(displayLinkAction:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSRunLoopCommonModes];
    self.displayLink.paused = YES;
  }
  return self;
}

#pragma mark - public

- (void)fireWithVelocity:(CGPoint)velocity from:(CGPoint)from {
  self.displayLink.paused = YES;
  self.currentVelocity = velocity;
  self.currentPosition = from;
  self.displayLink.paused = NO;
}

- (void)stop {
  self.displayLink.paused = YES;
}

#pragma mark - CADisplayLink

- (void)displayLinkAction:(CADisplayLink *)link {
  CGFloat time = (CGFloat)link.duration;
  CGPoint frictionForce =
      CGPointMake(self.frictionRatio * self.currentVelocity.x,
                  self.frictionRatio * self.currentVelocity.y);
  CGPoint move = CGPointMake(
      time * self.currentVelocity.x + time * time * frictionForce.x,
      time * self.currentVelocity.y + time * time * frictionForce.y);

  self.currentPosition = CGPointMake(self.currentPosition.x + move.x,
                                     self.currentPosition.y + move.y);
  self.currentVelocity =
      CGPointMake(self.currentVelocity.x - frictionForce.x * time,
                  self.currentVelocity.y - frictionForce.y * time);

  if (fabs(self.currentVelocity.x) + fabs(self.currentVelocity.y) <= 1) {
    link.paused = YES;
  }
  void (^refreshHandler)(CGPoint, CGPoint) = self.refreshHandler;
  if (refreshHandler) {
    refreshHandler(self.currentPosition, self.currentVelocity);
  }
}

@end
