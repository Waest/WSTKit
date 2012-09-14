//
//  SVTopViewController.m
//  SlidingViewController
//
//  Created by Aurélien AMILIN on 12/09/12.
//  Copyright (c) 2012 Aurélien AMILIN. All rights reserved.
//

#import "WSTopViewController.h"
#import "UIApplication+StatusBarNotifications.h"

@interface WSTopViewController () {
    UITableView *_tableView;
}
@end

@implementation WSTopViewController
@synthesize slidingViewControllerHandler;

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.frame = self.view.bounds;
    [_tableView release];
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
}

/////////////////////////////////////////////
- (void)toolbarItemPressed:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHiddenWithNotifications:![UIApplication sharedApplication].statusBarHidden withAnimation:UIStatusBarAnimationSlide];
}

/////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

/////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"Line %i", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [[UIApplication sharedApplication] setStatusBarHiddenWithNotifications:![UIApplication sharedApplication].statusBarHidden];
//    [self.navigationController setNavigationBarHidden:![self.navigationController isNavigationBarHidden] animated:NO];
}

@end
