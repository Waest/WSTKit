//
//  SVMenuViewController.m
//  SlidingViewController
//
//  Created by Aurélien AMILIN on 12/09/12.
//  Copyright (c) 2012 Aurélien AMILIN. All rights reserved.
//

#import "WSMenuViewController.h"
#import "WSTopViewController.h"

@interface WSMenuViewController ()

@end

@implementation WSMenuViewController
@synthesize slidingViewControllerHandler;

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView release];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

///////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Item %i", indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WSTopViewController *topController = [[[WSTopViewController alloc] init] autorelease];
    topController.title = [NSString stringWithFormat:@"Controller %i", indexPath.row];
    if (indexPath.row % 2 == 0) {
        UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:topController] autorelease];
        [slidingViewControllerHandler replaceTopViewController:navController];
    }
    else {
        [slidingViewControllerHandler replaceTopViewController:topController];
    }

}

@end
