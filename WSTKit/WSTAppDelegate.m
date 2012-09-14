//
//  WSTAppDelegate.m
//  WSTKit
//
//  Created by Aurélien AMILIN on 14/09/12.
//  Copyright (c) 2012 Aurélien AMILIN. All rights reserved.
//

#import "WSTAppDelegate.h"
#import "Demos/WSTopViewController.h"
#import "Demos/WSMenuViewController.h"

@implementation WSTAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    WSTopViewController *topController = [[[WSTopViewController alloc] init] autorelease];
    WSMenuViewController *menuController = [[[WSMenuViewController alloc] init] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:topController] autorelease];
    WSSlidingViewControllerHandler *slidingHandler = [[WSSlidingViewControllerHandler alloc] init];
    topController.slidingViewControllerHandler = slidingHandler;
    [slidingHandler setLeftViewController:menuController];
    [slidingHandler setTopViewController:navController];
    self.window.rootViewController = slidingHandler;
    [slidingHandler release];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
