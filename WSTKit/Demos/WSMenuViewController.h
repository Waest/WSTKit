//
//  SVMenuViewController.h
//  SlidingViewController
//
//  Created by Aurélien AMILIN on 12/09/12.
//  Copyright (c) 2012 Aurélien AMILIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WSSliddingViewController> {
    UITableView *_tableView;
}

@end
