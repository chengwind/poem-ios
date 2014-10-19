//
//  XYFifthViewController.h
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPoemService.h"
#import "MJRefresh.h"

@interface XYAuthorsViewController : UITableViewController<MJRefreshBaseViewDelegate,UISearchBarDelegate>
{
    XYPoemService *service;
    MJRefreshFooterView *_footer;
}

@property(nonatomic,retain)NSMutableArray *data;
@property BOOL isEnd;
@property(nonatomic,strong) NSString *dynasty_name;
@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;

@end
