//
//  WSSlidingViewController.h
//  SlidingViewController
//
//  Created by Aurélien AMILIN on 12/09/12.
//  Copyright (c) 2012 Aurélien AMILIN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WSStatusBarFrameWillChangeNotification @"WSStatusBarFrameWillChangeNotification"

@class WSSlidingViewControllerHandler;
@protocol WSSliddingViewController <NSObject>
@property(nonatomic, assign) WSSlidingViewControllerHandler *slidingViewControllerHandler;
@end

@interface WSSlidingViewControllerHandler : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic, retain, setter=_setLeftViewController:) UIViewController *leftViewController;
@property(nonatomic, retain, setter=_setTopViewController:) UIViewController *topViewController;

@property(nonatomic, assign) CGFloat rightAnchorWidth;
@property(nonatomic, assign) CGFloat anchorBouncingWidth;

@property(nonatomic, readonly) UITapGestureRecognizer *tap;
@property(nonatomic, readonly) UIPanGestureRecognizer *pan;


- (void)setTopViewController:(UIViewController *)topViewController;
- (void)setLeftViewController:(UIViewController *)leftViewController;

- (void)showLeftViewController;
- (void)showTopViewController;
- (void)replaceTopViewController:(UIViewController *)viewController;
@end
