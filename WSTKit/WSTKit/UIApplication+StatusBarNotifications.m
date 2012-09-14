//
//  UIApplication+StatusBarNotifications.m
//  SlidingViewController
//
//  Created by Aurélien AMILIN on 13/09/12.
//  Copyright (c) 2012 Aurélien AMILIN. All rights reserved.
//

#import "UIApplication+StatusBarNotifications.h"

@interface UIApplication (StatusBarNotificationsPrivate)
- (void)hideStatusBar:(BOOL)hide withNotifications:(void (^)(void))hideBlock andAnimation:(UIStatusBarAnimation)animation;
@end

@implementation UIApplication (StatusBarNotifications)

- (void)setStatusBarHiddenWithNotifications:(BOOL)statusBarHidden {
    [self hideStatusBar:statusBarHidden withNotifications:^{
        [self setStatusBarHidden:statusBarHidden];
    } andAnimation:-1];
}

- (void)setStatusBarHiddenWithNotifications:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation {
    [self hideStatusBar:hidden withNotifications:^{
        [self setStatusBarHidden:hidden withAnimation:animation];
    } andAnimation:animation];
}

- (void)hideStatusBar:(BOOL)hide withNotifications:(void (^)(void))hideBlock andAnimation:(UIStatusBarAnimation)animation {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:hide], UIApplicationHideStatusBarNotificationHideKey, [NSNumber numberWithInt:animation], UIApplicationHideStatusBarNotificationAnimationKey, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillHideStatusBarNotification object:userInfo];
    hideBlock();
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidHideStatusBarNotification object:userInfo];
}

@end
