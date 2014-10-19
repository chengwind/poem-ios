//
//  XYListViewController.h
//  RDVTabBarController
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "XYPoemService.h"

@interface XYPoemListViewController : UITableViewController<MJRefreshBaseViewDelegate,UISearchBarDelegate>
{
    MJRefreshFooterView *_footer;
    NSMutableArray *data;
    XYPoemService *service;
}
@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@property int searchCatId;
@property NSString *searchCatName;
//@property int offset;
@property BOOL isEnd;
@property(nonatomic,strong) NSString *searchType;
@property(nonatomic,strong) NSString *searchText;

@end
