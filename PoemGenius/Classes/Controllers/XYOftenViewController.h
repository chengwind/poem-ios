//
//  XYFourthViewController.h
//  RDVTabBarController
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPoemService.h"

@interface XYOftenViewController : UITableViewController
{
        XYPoemService *service;
}

@property(nonatomic,strong)NSMutableArray *data;

@end
