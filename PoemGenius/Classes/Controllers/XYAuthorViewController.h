//
//  XYDetailViewController.h
//  RDVTabBarController
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
#import "XYAuthor.h"
#import "XYPoemService.h"

@interface XYAuthorViewController : UIViewController<CMPopTipViewDelegate>

{
    CMPopTipView *settingPopTipView;
    XYPoemService *service;
}

@property float currentBrightness;
@property(nonatomic,retain) IBOutlet UILabel *uilabel;
@property(nonatomic,retain) IBOutlet UISlider *uislider;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnFav;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnSetting;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnShare;
@property(nonatomic,retain) IBOutlet UITextView *tvContent;

@property (strong, nonatomic) IBOutlet UIToolbar *uiToolbar;

-(IBAction)buttonAction:(id)sender;

@property int uid;
@property XYAuthor *author;
@property BOOL showed;

@end
