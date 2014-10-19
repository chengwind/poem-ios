//
//  XYPageAppViewController.m
//  PoemGenius
//
//  Created by jason on 4/2/14.
//  Copyright (c) 2014 XiaoYao. All rights reserved.
//

#import "XYAboutViewController.h"
#import "XYOftenViewController.h"
#import "XYCategoryViewController.h"
#import "XYSearchViewController.h"
#import "XYAuthorListViewController.h"
#import "XYFavViewController.h"


@interface XYAboutViewController ()

@end

@implementation XYAboutViewController

@synthesize lbTitle,tvDesc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    if (self) {
        self.title =@"关于";
        [lbTitle setText:[NSString stringWithFormat:@"关于"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(performBackNavigation:)];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        CGRect cgr1 =CGRectMake(0,44+20,self.view.frame.size.width,20);
        lbTitle = [[UILabel alloc]initWithFrame:cgr1];
        CGRect cg1 = [[UIScreen mainScreen] bounds];
        CGFloat height1 =cg1.size.height-44;
        NSLog(@"!!!!!,%f,%f,%f",cg1.size.height,height1,self.navigationController.navigationBar.bounds.size.height);
        CGRect cgr2 =CGRectMake(0,44+40,cg1.size.width, height1-40);
        tvDesc = [[UITextView alloc]initWithFrame:cgr2];
    }else{
        CGRect cgr1 =CGRectMake(0,0,self.view.frame.size.width,20);
        lbTitle = [[UILabel alloc]initWithFrame:cgr1];
        CGRect cg1 = [[UIScreen mainScreen] bounds];
        CGFloat height1 =cg1.size.height-20-20-44;
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

- (void)performBackNavigation:(id)sender
{
//    UIViewController *firstViewController = [[XYOftenViewController alloc] init];
//    UIViewController *firstNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:firstViewController];
//    
//    UIViewController *secondViewController = [[XYCategoryViewController alloc] init];
//    UIViewController *secondNavigationController = [[UINavigationController alloc]
//                                                    initWithRootViewController:secondViewController];
//    
//    UIViewController *thirdViewController = [[XYSearchViewController alloc] init];
//    UIViewController *thirdNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:thirdViewController];
//    
//    UIViewController *fourthViewController = [[XYAuthorListViewController alloc] init];
//    UIViewController *fourthNavigationController = [[UINavigationController alloc]
//                                                    initWithRootViewController:fourthViewController];
//    
//    UIViewController *fifthViewController = [[XYFavViewController alloc] init];
//    UIViewController *fifthNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:fifthViewController];
    
//    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
//    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
//                                           thirdNavigationController,fourthNavigationController,fifthNavigationController]];
//    [self.sideMenuViewController setContentViewController:tabBarController];
//    [self customizeTabBarForController:tabBarController];
}
//
//- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
//    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
//    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
//    NSArray *tabBarItemImages = @[@"first", @"second", @"second",@"third",@"first"];
//    
////    NSInteger index = 0;
////    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
////        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
////        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
////                                                      [tabBarItemImages objectAtIndex:index]]];
////        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
////                                                        [tabBarItemImages objectAtIndex:index]]];
////        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
////        
////        index++;
////    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lbTitle setText:[NSString stringWithFormat:@"关于"]];
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
