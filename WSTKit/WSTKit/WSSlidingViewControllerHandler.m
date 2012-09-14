//
//  WSSlidingViewController.m
//  SlidingViewController
//
//  Created by Aurélien AMILIN on 12/09/12.
//  Copyright (c) 2012 Aurélien AMILIN. All rights reserved.
//

#import "WSSlidingViewControllerHandler.h"
#import "UIApplication+StatusBarNotifications.h"

#define WSSlidingProtectionViewTag 75002

typedef enum {
    ShowingTopViewController,
    ShowingLeftViewController,
} HandlerState;

typedef enum {
    Left,
    Right
} WSDirection;


@interface WSSlidingViewControllerHandler () {
    HandlerState state;
    CGPoint lastPanTranslation;
    UIView *contentView;
    BOOL isMovingControllers;
}

- (void)moveTopControllerToX:(CGFloat)newX;
- (BOOL)canShowViewController:(UIViewController *)viewController;
@end

@implementation WSSlidingViewControllerHandler
@synthesize topViewController=_topViewController;
@synthesize leftViewController=_leftViewController;
@synthesize rightAnchorWidth;
@synthesize anchorBouncingWidth;
@synthesize tap;
@synthesize pan;

- (id)init {
    if (self = [super init]) {
        anchorBouncingWidth = 20;
        rightAnchorWidth = 40;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        lastPanTranslation = CGPointZero;
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        pan.delegate = self;
        contentView = [[UIView alloc] init];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        contentView.backgroundColor = [UIColor redColor];
        state = ShowingTopViewController;
        isMovingControllers = NO;
    }
    return self;
}

- (void)loadView {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
	UIView *view = [[UIView alloc] initWithFrame:screenBounds];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	view.backgroundColor = [UIColor blueColor];
    
    contentView.frame = screenBounds;
	contentView.backgroundColor = [UIColor greenColor];
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[view addSubview:contentView];
    
	self.view = view;
}

- (void)dealloc {
    [contentView release];
    contentView = nil;
    [tap release];
    tap = nil;
    [pan release];
    pan = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarWillHide:) name:UIApplicationWillHideStatusBarNotification object:nil];
}


- (void)setTopViewController:(UIViewController *)topViewController {
    [_topViewController.view removeGestureRecognizer:pan];
    [self addViewControllerToHierarchy:topViewController];
    [self _setTopViewController:topViewController];
    [topViewController.view addGestureRecognizer:pan];
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    [self addViewControllerToHierarchy:leftViewController];
    [self _setLeftViewController:leftViewController];
}

- (void)addViewControllerToHierarchy:(UIViewController *)viewController {
    [viewController removeFromParentViewController];
    [viewController.view removeFromSuperview];
    if ([viewController respondsToSelector:@selector(setSlidingViewControllerHandler:)]) {
        [((UIViewController <WSSliddingViewController>*)viewController) setSlidingViewControllerHandler:self];
    }
    [self addChildViewController:viewController];
    [contentView addSubview:viewController.view];
    viewController.view.frame = contentView.bounds;
}

//////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    BOOL shouldRotate = NO;
    switch (state) {
        case ShowingTopViewController:
            shouldRotate = [_topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
            break;
        case ShowingLeftViewController:
            shouldRotate = [_topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation] && [_leftViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
            break;
    }
    return shouldRotate;
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (state == ShowingLeftViewController) {
        [self showLeftViewController:NO];
    }
}

//////////////////////////////////////////////

- (void)statusBarWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = notification.object;
    BOOL barWillHide = [[userInfo valueForKey:UIApplicationHideStatusBarNotificationHideKey] boolValue];
    BOOL animated = [[userInfo valueForKey:UIApplicationHideStatusBarNotificationAnimationKey] intValue] > 0;
    UIStatusBarStyle statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    CGFloat statusBarHeight = 20;
    if (self.wantsFullScreenLayout && statusBarStyle == UIStatusBarStyleBlackTranslucent) {
//        statusBarHeight = barWillHide ? 0: 20;
    }
    
    
    if (animated) {
        [UIView beginAnimations:@"ResizeViews" context:nil];
        [UIView setAnimationDuration:barWillHide ? 0.2 : 0.35];
    }
    
    if (self.wantsFullScreenLayout) {
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }
    else {
        CGRect viewFrame = self.view.frame;
        
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        switch (currentOrientation) {
            case UIInterfaceOrientationPortrait:
                if (barWillHide) {
                    viewFrame.origin.y = 0;
                    viewFrame.size.height += statusBarHeight;
                }
                else {
                    viewFrame.origin.y = statusBarHeight;
                    viewFrame.size.height -= statusBarHeight;
                }
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                if (barWillHide) {
                    viewFrame.origin.y = 0;
                    viewFrame.size.height += statusBarHeight;
                }
                else {
                    viewFrame.origin.y = 0;
                    viewFrame.size.height -= statusBarHeight;
                }
                break;
            case UIInterfaceOrientationLandscapeLeft:
                if (barWillHide) {
                    viewFrame.origin.x = 0;
                    viewFrame.size.width += statusBarHeight;
                }
                else {
                    viewFrame.origin.x = statusBarHeight;
                    viewFrame.size.width -= statusBarHeight;
                }
                break;
            case UIInterfaceOrientationLandscapeRight:
                if (barWillHide) {
                    viewFrame.origin.x = 0;
                    viewFrame.size.width += statusBarHeight;
                }
                else {
                    viewFrame.origin.x = 0;
                    viewFrame.size.width -= statusBarHeight;
                }
                break;
            default:
                break;
        }
        
        self.view.frame = viewFrame;
    }
    
    
    
    if (animated) {
        [UIView commitAnimations];
    }
}

//////////////////////////////////////////////

- (void)showLeftViewController {
    [self showLeftViewController:YES];
}

- (void)showLeftViewController:(BOOL)animated {
    CGFloat newX = CGRectGetWidth(self.view.bounds) - rightAnchorWidth;
    if (animated) {
        [UIView beginAnimations:@"showLeftViewController" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(showingLeftViewControllerDidStop:)];
        newX += anchorBouncingWidth;
    }
    
    _topViewController.view.frame = CGRectMake(newX, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    
    if (animated) {
        [UIView commitAnimations];
    }
    else {
        state = ShowingLeftViewController;
        [_topViewController.view addGestureRecognizer:tap];
    }
}

- (void)showingLeftViewControllerDidStop:(id)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
        _topViewController.view.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - rightAnchorWidth, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    } completion:^(BOOL finished) {
        state = ShowingLeftViewController;
        [_topViewController.view addGestureRecognizer:tap];
    }];
}

- (void)showTopViewController {
    [self showTopViewController:YES];
}

- (void)showTopViewController:(BOOL)animated {
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
        _topViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    } completion:^(BOOL finished) {
        state = ShowingTopViewController;
        [_topViewController.view removeGestureRecognizer:tap];
    }];
}

- (void)replaceTopViewController:(UIViewController *)viewController {
    [self executeUnlessAlreadyMovingControllers:^{
        CGRect hiddenFrame = _topViewController.view.frame;
        switch (state) {
            case ShowingLeftViewController:
                hiddenFrame = CGRectMake(CGRectGetWidth(self.view.bounds) + 10, 0, CGRectGetWidth(contentView.bounds), CGRectGetHeight(contentView.bounds));
                break;
            default:
                break;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _topViewController.view.frame = hiddenFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                [self setTopViewController:viewController];
                _topViewController.view.frame = hiddenFrame;
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                    _topViewController.view.frame = contentView.bounds;
                } completion:^(BOOL finished) {
                    if(finished) {
                        state = ShowingTopViewController;
                        isMovingControllers = NO;
                    }
                }];
            }
        }];
    }];
}

//////////////////////////////////////////////

- (void)protectControllersFromUserInteractions:(NSArray *)controllers {
    for (UIViewController *controller in controllers) {
        [controller.view addSubview:[self createProtectingViewForController:controller]];
    }
}

- (void)unprotectControllersFromUserInteractions:(NSArray *)controllers {
    for (UIViewController *controller in controllers) {
        [[controller.view viewWithTag:WSSlidingProtectionViewTag] removeFromSuperview];
    }
}

- (UIView *)createProtectingViewForController:(UIViewController *)controller {
    UIView *view = [[UIView alloc] initWithFrame:controller.view.bounds];
    view.tag = WSSlidingProtectionViewTag;
    view.backgroundColor = [UIColor clearColor];
    return [view autorelease];
}

//////////////////////////////////////////////

- (void)executeUnlessAlreadyMovingControllers:(void(^)(void))block {
    if (isMovingControllers == NO) {
        isMovingControllers = YES;
        block();
    }
}

//////////////////////////////////////////////

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [pan translationInView:self.view];
    CGFloat distanceCovered = translation.x - lastPanTranslation.x;
    CGFloat newX = CGRectGetMinX(_topViewController.view.frame) + distanceCovered;
    
    lastPanTranslation = translation;
    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        [self moveTopControllerToX:newX];
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [pan velocityInView:self.view];
        CGFloat magnitude = sqrtf(powf(velocity.x, 2) + powf(velocity.y, 2));
        WSDirection panDirection = velocity.x > 0 ? Right : Left;
        [self handlePanningEnd:magnitude direction:panDirection position:newX];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    [self showTopViewController];
}


- (void)handlePanningEnd:(CGFloat)magnitude direction:(WSDirection)direction position:(CGFloat)positionX {
    CGFloat animationStartLimit = CGRectGetWidth(self.view.bounds) / 2.0f;
    switch (state) {
        case ShowingLeftViewController:
            if (positionX < animationStartLimit || (magnitude > 600 && direction == Left))
                [self showTopViewController];
            else
                [self showLeftViewController];
            break;
        case ShowingTopViewController:
            if (positionX > animationStartLimit || (magnitude > 600 && direction == Right))
                [self showLeftViewController];
            else
                [self showTopViewController];
            break;
    }
    lastPanTranslation = CGPointZero;
}

/////////////////////////////////////////////////////////

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL shouldReceiveTouch = false;
    if (gestureRecognizer == pan) {
        CGPoint position = [touch locationInView:touch.view];
        if (position.x < rightAnchorWidth) {
            shouldReceiveTouch = YES;
        }
    }
    
    return shouldReceiveTouch;
}

/////////////////////////////////////////////////////////

- (void)moveTopControllerToX:(CGFloat)positionX {
    if ([self canShowViewController:[self showedViewControllerWhenTopControllerAtPosition:positionX]]) {
        _topViewController.view.frame = CGRectMake(positionX, 0, CGRectGetWidth(_topViewController.view.bounds), CGRectGetHeight(_topViewController.view.bounds));
    }
}

- (UIViewController *)showedViewControllerWhenTopControllerAtPosition:(CGFloat)positionX {
    UIViewController *viewController = nil;
    if (positionX >= 0)
        viewController = _leftViewController;
    
    return viewController;
}

- (BOOL)canShowViewController:(UIViewController *)viewController {
    return viewController != nil;
}

@end
