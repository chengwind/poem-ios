//
//  XYPageAppViewController.h
//  PoemGenius
//
//  Created by jason on 4/2/14.
//  Copyright (c) 2014 XiaoYao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPoem.h"

@interface XYContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
//@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextView *tvDesc;
@property XYPoem *poem;

@end
