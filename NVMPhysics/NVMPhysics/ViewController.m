//
//  ViewController.m
//  NVMPhysics
//
//  Created by PhilCai on 7/12/16.
//  Copyright © 2016 Phil. All rights reserved.
//

#import "NVMPhysicsAnimator.h"
#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, strong) UIView *redBox;
@property(nonatomic, strong) NVMPhysicsAnimator *animator;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setup];
}

- (void)setup {
  [self loadSubview];
  [self loadGesture];
  [self loadAnimator];
}

- (void)loadSubview {
  self.redBox = [UIView new];
  self.redBox.backgroundColor = [UIColor redColor];
  self.redBox.frame = CGRectMake(100, 80, 100, 100);
  [self.view addSubview:self.redBox];
}

- (void)loadAnimator {
  __weak typeof(self) weakSelf = self;
  self.animator = [[NVMPhysicsAnimator alloc] initWithFrictionRatio:3 springRatio:30];
  [self.animator setRefreshHandler:^(CGPoint position, CGPoint velocity) {
    weakSelf.redBox.center = position;
    NSLog(@"Center:[%.2f,%.2f], Velocity:[%.2f,%.2f]",
          position.x, position.y, velocity.x, velocity.y);
  }];
}

- (void)loadGesture {
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handlePanGesture:)];
  [self.redBox addGestureRecognizer:pan];
}

#pragma mark - gesture

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
  switch (pan.state) {
  case UIGestureRecognizerStatePossible: {

  } break;
  case UIGestureRecognizerStateBegan: {
    [self.animator stop];
  } break;
  case UIGestureRecognizerStateChanged: {
    CGPoint move = [pan translationInView:self.redBox];
    self.redBox.center = CGPointMake(self.redBox.center.x + move.x,
                                     self.redBox.center.y + move.y);
  } break;
  case UIGestureRecognizerStateEnded: {
    CGPoint velocity = [pan velocityInView:self.redBox];
    NSLog(@"Final velocity = %@", NSStringFromCGPoint(velocity));
    [self.animator fireWithVelocity:velocity from:self.redBox.center];
  } break;
  default:
    break;
  }
  [pan setTranslation:CGPointZero inView:self.redBox];
}

@end
