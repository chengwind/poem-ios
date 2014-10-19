//
//  XYDetailViewController.m
//  RDVTabBarController
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import "XYAuthorViewController.h"
#import "XYPoemListViewController.h"
#import "UMSocial.h"

@interface XYAuthorViewController ()

@end

@implementation XYAuthorViewController

@synthesize currentBrightness,uilabel,uislider,btnFav, btnSetting,btnShare;

@synthesize uiToolbar;

- (void) awakeFromNib
{
    if (self) {
        self.title = @"诗人";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[[NSString alloc]initWithFormat:@"%i首",100]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(nav)];
}

- (void)nav
{
    //    XYPoemListViewController *viewController  =[[XYPoemListViewController alloc] init];
    //    viewController.searchType=@"a";
    //    viewController.searchId = self.author.uid;
    //	[self.navigationController pushViewController:viewController animated:TRUE];
    
    [self performSegueWithIdentifier:@"showPoemListSegue" sender:self.author];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPoemListSegue"])
    {
        XYPoemListViewController *vc = [segue destinationViewController];
        
        //        XYCategory *category =[data objectAtIndex:((NSIndexPath *)sender).row];
        vc.searchType=@"a";
        vc.searchCatId = ((XYAuthor *)sender).uid;
        vc.searchCatName = ((XYAuthor *)sender).name;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [btnFav setAction: @selector(doFav)];
    [btnShare setAction: @selector(share)];
    if(service==nil){
        service =[[XYPoemService alloc]init];
    }
    self.author = [service getAuthor:self.uid];
    if([self.author.is_fav isEqualToString:@"1"])
    {
        self.title  = [[NSString alloc]initWithFormat:@"🌟%@",self.author.name];
    }else{
        self.title = self.author.name;
    }
    [self.navigationItem.rightBarButtonItem setTitle:[[NSString alloc]initWithFormat:@"%i首",self.author.poem_num]];
    NSString *lb = @"";
    if(self.author.des){
        lb = [lb stringByAppendingFormat:@"%@ ",self.author.des];
    }else{
        lb = [lb stringByAppendingFormat:@"%@ ",@"没有作者简介."];
    }
    [self.tvContent setText:lb];
    
    [self.uiToolbar setBackgroundImage:[UIImage new]
                    forToolbarPosition:UIBarPositionAny
                            barMetrics:UIBarMetricsDefault];
    [self.uiToolbar setShadowImage:[UIImage new]
                forToolbarPosition:UIToolbarPositionAny];
    self.showed =false;
}

-(void)doFav{
    if([self.author.is_fav isEqual:@"1"]){
        [service updateAuthor:self.uid isFav:@"0"];
        self.author.is_fav =@"0";
        NSString *message = [[NSString alloc]initWithFormat:@"已取消收藏诗人:%@",self.author.name];
        self.title  = self.author.name;
        UIAlertView * alertA= [[UIAlertView alloc] initWithTitle:@"信息" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertA show];
        
    }else{
        [service updateAuthor:self.uid isFav:@"1"];
        self.author.is_fav =@"1";
        NSString *message = [[NSString alloc]initWithFormat:@"已收藏诗人:%@",self.author.name];
        self.title  = [[NSString alloc]initWithFormat:@"🌟%@",self.author.name];
        UIAlertView * alertA= [[UIAlertView alloc] initWithTitle:@"信息" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertA show];
    }
}
-(void)share{
    NSString *aaa = @"";
    aaa= self.author.name;
    
    if(self.author.des){
        aaa = [aaa stringByAppendingFormat:@"%@ : ",self.author.des];
    }else{
        aaa = [aaa stringByAppendingFormat:@"%@ : ",@"没有作者简介."];
    }
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY                                      shareText:aaa
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToDouban,UMShareToEmail,UMShareToSms,nil]
                                       delegate:nil];
}


- (IBAction)buttonAction:(id)sender {
    if(self.showed && settingPopTipView!=nil){
        [settingPopTipView dismissAnimated:true];
        self.showed =false;
        return;
    }
    // Present a CMPopTipView pointing at a UIBarButtonItem in the nav bar
    currentBrightness =(int)([[UIScreen mainScreen] brightness]*10.0)/10.0;
    
    if (nil == settingPopTipView) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width*0.8, 130)];
        
        uilabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.8*0.1,0, self.view.frame.size.width*0.8*0.8, 20)];
        
        uilabel.backgroundColor=[UIColor clearColor];
        //        uilabel.text = [[NSString alloc] initWithFormat:@"亮度调节[%.1f]",currentBrightness];
        uilabel.textColor =[UIColor yellowColor];
        
        
        uislider=[[UISlider alloc]init];
        uislider.frame = CGRectMake(self.view.frame.size.width*0.8*0.1, 25, self.view.frame.size.width*0.8*0.8, 50);
        uislider.minimumValue = 0.0;
        uislider.maximumValue = 1.0;
        uislider.continuous = YES;
        
        [uislider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        UIButton *button1 = [[UIButton alloc]init];
        button1.frame =CGRectMake(self.view.frame.size.width*0.8/2-80-30, 90, 60, 20);
        [button1 setTitle:@" 确 定 " forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button2 = [[UIButton alloc]init];
        button2.frame =CGRectMake(self.view.frame.size.width*0.8/2+80-30, 90, 60, 20);
        [button2 setTitle:@" 取 消 " forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [contentView addSubview:uilabel];
        [contentView addSubview:uislider];
        [contentView addSubview:button1];
        [contentView addSubview:button2];
        settingPopTipView = [[CMPopTipView alloc] initWithCustomView:contentView];
    }
    uilabel.text =[[NSString alloc]initWithFormat:@"亮度调节 ( %.1f )",currentBrightness];
    uislider.value = currentBrightness;
    settingPopTipView.backgroundColor = [UIColor darkGrayColor];
    settingPopTipView.textColor =[UIColor blueColor];
    
    settingPopTipView.delegate = self;
    [settingPopTipView presentPointingAtBarButtonItem:btnSetting animated:YES];
    self.showed =true;
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // Any cleanup code, such as releasing a CMPopTipView instance variable, if necessary
    self.showed =false;
    [popTipView dismissAnimated:YES];
}

- (IBAction)buttonAction2:(id)sender {
    if([[sender currentTitle]  isEqualToString: @" 取 消 "])
    {
        [[UIScreen mainScreen] setBrightness:currentBrightness];
        [settingPopTipView dismissAnimated:YES];
    }else if ([[sender currentTitle]  isEqualToString: @" 确 定 "]){
        [[UIScreen mainScreen] setBrightness:uislider.value];
        [settingPopTipView dismissAnimated:YES];
    }
    self.showed =false;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
//    NSLog(@"slider value = %f", sender.value);
    if(sender == self.uislider){
        float v =(int)(sender.value*10.0)/10.0;
        [sender setValue:v animated:NO];
        uilabel.text = [[NSString alloc] initWithFormat:@"亮度调节[%.1f]",v];
        [[UIScreen mainScreen] setBrightness:sender.value];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    //       [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    //    NSLog(@"0##-%hhd",self.tabBarController.tabBar.isHidden);
    [self.tabBarController.tabBar setHidden:YES];
    //    NSLog(@"1##-%hhd",self.tabBarController.tabBar.isHidden);
}

-(void) viewWillDisappear:(BOOL)animated{
    //    NSLog(@"2##-%hhd",self.tabBarController.tabBar.isHidden);
    
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

@end
