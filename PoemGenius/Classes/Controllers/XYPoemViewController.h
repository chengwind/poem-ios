//
//  XYDetailViewController.h
//  RDVTabBarController
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
#import "XYPoemService.h"
#import "XYPoem.h"
#import "UMSocial.h"

@interface XYPoemViewController : UIViewController<CMPopTipViewDelegate,UMSocialUIDelegate>
{
    UIPageViewController *pageController;
    CMPopTipView *settingPopTipView;
    XYPoemService *service;
}

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *ids;
@property (strong, nonatomic) IBOutlet UIToolbar *uiToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnPrevious;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNext;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnFav;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnSetting;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnShare;

@property(nonatomic,retain) IBOutlet UILabel *uilabel;
@property(nonatomic,retain) IBOutlet UISlider *uislider;

@property(nonatomic,retain) IBOutlet UILabel *uilabel1;
@property(nonatomic,retain) IBOutlet UISlider *uislider1;
@property(nonatomic,retain) IBOutlet UITextView *tvContent;

@property float currentBrightness;
@property int currentPoem;

@property int idx;

@property int uid;
@property XYPoem *poem;
@property BOOL showed;

//-(IBAction)moveNext;
//-(IBAction)movePrevious;
-(IBAction)buttonAction:(id)sender;
-(IBAction)buttonAction2:(id)sender;

@end
