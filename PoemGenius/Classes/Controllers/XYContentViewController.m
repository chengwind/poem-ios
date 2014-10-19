//
//  XYPageAppViewController.m
//  PoemGenius
//
//  Created by jason on 4/2/14.
//  Copyright (c) 2014 XiaoYao. All rights reserved.
//

#import "XYContentViewController.h"

@interface XYContentViewController ()

@end

@implementation XYContentViewController

@synthesize lbTitle,tvDesc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    if (self) {
//        [lbTitle setText:[NSString stringWithFormat:@"AAAA×-%@",dataObject]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        CGRect cgr1 =CGRectMake(0,20,self.view.frame.size.width,20);
        lbTitle = [[UILabel alloc]initWithFrame:cgr1];
        CGRect cg1 = [[UIScreen mainScreen] bounds];
        CGFloat height1 =cg1.size.height-20-20-44-44;
        NSLog(@"!!!!!,%f,%f,%f",cg1.size.height,height1,self.navigationController.navigationBar.bounds.size.height);
        CGRect cgr2 =CGRectMake(0,40,cg1.size.width, height1);
        tvDesc = [[UITextView alloc]initWithFrame:cgr2];
    }else{
        CGRect cgr1 =CGRectMake(0,0,self.view.frame.size.width,20);
        lbTitle = [[UILabel alloc]initWithFrame:cgr1];
        CGRect cg1 = [[UIScreen mainScreen] bounds];
        CGFloat height1 =cg1.size.height-20-20-44-44;
        NSLog(@"!!!!!,%f,%f,%f",cg1.size.height,height1,self.navigationController.navigationBar.bounds.size.height);
        CGRect cgr2 =CGRectMake(0,20,cg1.size.width, height1);
        tvDesc = [[UITextView alloc]initWithFrame:cgr2];
    }
    

    [lbTitle setText:@"诗名B"];
    [lbTitle setBackgroundColor:[UIColor blueColor]];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:lbTitle];
    [tvDesc setBackgroundColor:[UIColor grayColor]];
    [tvDesc setEditable:NO];
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        [tvDesc setSelectable:NO];
    }else{
        tvDesc.editable= NO;
    }
    [tvDesc setText:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."];
    [[self view] addSubview:tvDesc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [lbTitle setText:[NSString stringWithFormat:@"AAAA#-%@",dataObject]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
