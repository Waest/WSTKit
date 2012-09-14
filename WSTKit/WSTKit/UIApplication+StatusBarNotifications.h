//
//  UIApplication+StatusBarNotifications.h
//  SlidingViewController
//
//  Created by Aurélien AMILIN on 13/09/12.
//  Copyright (c) 2012 Aurélien AMILIN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIApplicationDidHideStatusBarNotification @"UIApplicationDidHideStatusBarNotification"
#define UIApplicationWillHideStatusBarNotification @"UIApplicationWillHideStatusBarNotification"

#define UIApplicationHideStatusBarNotificationHideKey @"UIApplicationWillHideStatusBarNotificationHideKey"
#define UIApplicationHideStatusBarNotificationAnimationKey @"UIApplicationWillHideStatusBarNotificationAnimationKey"

@interface UIApplication (StatusBarNotifications)
- (void)setStatusBarHiddenWithNotifications:(BOOL)statusBarHidden;
- (void)setStatusBarHiddenWithNotifications:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;
@end
