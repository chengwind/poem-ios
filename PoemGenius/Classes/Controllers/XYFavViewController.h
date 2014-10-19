//
//  XYFifthViewController.h
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPoemService.h"
#import "MJRefresh.h"

@interface XYFavViewController : UITableViewController<MJRefreshBaseViewDelegate>
{
    XYPoemService *service;
    MJRefreshFooterView *_footer;
}

-(IBAction)EditData:(id)sender;
@property(nonatomic,retain)NSMutableArray *data;
@property(nonatomic,retain)UISegmentedControl *sc;
@property int selectedTab;
@property BOOL isEnd;
@end
