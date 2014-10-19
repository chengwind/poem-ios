//
//  XYDetailViewController.m
//  RDVTabBarController
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import "XYPoemViewController.h"
#import "XYContentViewController.h"
#import "XYAuthorViewController.h"
#import "UMSocial.h"

@interface XYPoemViewController ()
@end

@implementation XYPoemViewController

@synthesize pageController,ids;
@synthesize uiToolbar;
@synthesize btnNext,btnPrevious,btnFav,btnSetting,btnShare,idx;
@synthesize uislider,uilabel;
@synthesize uislider1,uilabel1;
@synthesize currentBrightness,currentPoem;

- (void) awakeFromNib
{
    if (self) {
        self.title = @"诗名";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"诗人名"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(nav)];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if(service==nil){
        service =[[XYPoemService alloc]init];
    }
    [self refreshUI];
    [self.uiToolbar setBackgroundImage:[UIImage new]
                    forToolbarPosition:UIBarPositionAny
                            barMetrics:UIBarMetricsDefault];
    [self.uiToolbar setShadowImage:[UIImage new]
                forToolbarPosition:UIToolbarPositionAny];
    [btnPrevious setAction: @selector(movePrevious)];
    [btnNext setAction: @selector(moveNext)];
    [btnFav setAction: @selector(doFav)];
    [btnShare setAction: @selector(share)];
    [self.tvContent.layer setCornerRadius:10];
    
    self.showed =false;
    
    UISwipeGestureRecognizer *swiperight =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.view addGestureRecognizer:swiperight];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.view addGestureRecognizer:swipeleft];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;

}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        if(idx >= ids.count -1 ){
            return;
        }
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:0.7f];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
        [self moveNext];
        [UIView commitAnimations];
    }else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if(idx <=0){
            return;
        }
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:0.7f];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
        [self movePrevious];
        [UIView commitAnimations];
    }else if (recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
    }else if (recognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
    }
}

-(void)refreshUI{
    self.poem = [service getPoem:[self uid]];
    if([self.poem.is_fav isEqualToString:@"1"])
    {
        self.title  = [[NSString alloc]initWithFormat:@"🌟%@",self.poem.title];
    }else{
        self.title = self.poem.title;
    }
    
    [self.navigationItem.rightBarButtonItem setTitle:self.poem.author_name];
    
    NSString *lb = @"";
    NSString *aaa = @"";
    lb = [lb stringByAppendingFormat:@"    %@\r\n",self.poem.title];
    
    if(self.poem.dynasty_name && self.poem.author_name){
        lb = [lb stringByAppendingFormat:@"【%@, %@】\r\n",self.poem.dynasty_name,self.poem.author_name];
    }
    
    if(self.poem.genre_name){
        aaa = [aaa stringByAppendingFormat:@" %@  ",self.poem.genre_name];
    }
    if(self.poem.rhythm_name){
        aaa = [aaa stringByAppendingFormat:@" %@ ",self.poem.rhythm_name];
    }
    if(![aaa isEqualToString:@""]){
        aaa = [NSString stringWithFormat: @"⌈ %@ ⌋",aaa];
        lb = [lb stringByAppendingFormat:@" %@ ",aaa];
    }
    
    lb = [lb stringByAppendingFormat:@" \r\n\r\n "];
    if(self.poem.content){
        lb = [lb stringByAppendingFormat:@"📘 %@ \r\n\r\n",self.poem.content];
    }
    
    if(self.poem.title_note){
        lb = [lb stringByAppendingFormat:@"【题注】\r\n%@ \r\n\r\n",self.poem.title_note];
    }
    
    if(self.poem.comment){
        lb = [lb stringByAppendingFormat:@"【解析】\r\n%@ \r\n\r\n",self.poem.comment];
    }
    if(self.poem.word_notes){
        lb = [lb stringByAppendingFormat:@"%@ \r\n\r\n",self.poem.word_notes];
    }
    [self.tvContent setText:lb];
}

-(void)movePrevious{
    if(idx >0){
        idx = idx - 1;
        self.uid =[[ids objectAtIndex:idx] intValue];
        [self refreshUI];
    }
    
}

-(void)moveNext{
    if(idx < ids.count -1 ){
        idx = idx + 1;
        self.uid =[[ids objectAtIndex:idx] intValue]  ;
        [self refreshUI];
    }
    
}
-(void)share{
    NSString *aaa = @"";
    aaa= self.poem.title;
    
    if(self.poem.dynasty_name && self.poem.author_name){
        aaa = [aaa stringByAppendingFormat:@"【%@, %@】\r\n",self.poem.dynasty_name,self.poem.author_name];
    }
    
    if(self.poem.genre_name){
        aaa = [aaa stringByAppendingFormat:@" %@  ",self.poem.genre_name];
    }
    if(self.poem.rhythm_name){
        aaa = [aaa stringByAppendingFormat:@" %@ ",self.poem.rhythm_name];
    }
    
    if(self.poem.content){
        aaa = [aaa stringByAppendingFormat:@" %@ \r\n\r\n",self.poem.content];
    }
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:aaa
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToDouban,UMShareToEmail,UMShareToSms,nil]
                                       delegate:self];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        NSString *message = [[NSString alloc]initWithFormat:@"分享成功: %@",[[response.data allKeys] objectAtIndex:0]];
        NSLog(@"分享成功: %@",[[response.data allKeys] objectAtIndex:0]);
        UIAlertView * alertA= [[UIAlertView alloc] initWithTitle:@"信息" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertA show];
    }else{
        NSString *message = [[NSString alloc]initWithFormat:@"分享出错: %@",[[response.data allKeys] objectAtIndex:0]];
        NSLog(@"分享出错: %@",[[response.data allKeys] objectAtIndex:0]);
        UIAlertView * alertA= [[UIAlertView alloc] initWithTitle:@"信息" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertA show];
    }
}


-(void)doFav{
    if([self.poem.is_fav isEqual:@"1"]){
        [service updatePoem:self.uid isFav:@"0"];
        self.poem.is_fav =@"0";
        NSString *message = [[NSString alloc]initWithFormat:@"已取消收藏诗:%@",self.poem.title];
        self.title  = self.poem.title;
        UIAlertView * alertA= [[UIAlertView alloc] initWithTitle:@"信息" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertA show];
    }else{
        [service updatePoem:self.uid isFav:@"1"];
        self.poem.is_fav =@"1";
        NSString *message = [[NSString alloc]initWithFormat:@"已收藏诗:%@",self.poem.title];
        self.title  = [[NSString alloc]initWithFormat:@"🌟%@",self.poem.title];
        UIAlertView * alertA= [[UIAlertView alloc] initWithTitle:@"信息" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertA show];
    }
}



- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // Any cleanup code, such as releasing a CMPopTipView instance variable, if necessary
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

- (IBAction)buttonAction:(id)sender {
    // Present a CMPopTipView pointing at a UIBarButtonItem in the nav bar
    if(self.showed && settingPopTipView!=nil){
        [settingPopTipView dismissAnimated:true];
        self.showed =false;
        return;
    }
    currentPoem = 1;
    currentBrightness =(int)([[UIScreen mainScreen] brightness]*10.0)/10.0;
    
    if (nil == settingPopTipView) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width*0.8, 200)];
        
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
        
        
        uilabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.8*0.1,80, self.view.frame.size.width*0.8*0.8, 20)];
        uilabel1.backgroundColor=[UIColor clearColor];
        uilabel1.textColor =[UIColor yellowColor];
        
        
        uislider1=[[UISlider alloc]init];
        uislider1.frame = CGRectMake(self.view.frame.size.width*0.8*0.1, 105, self.view.frame.size.width*0.8*0.8, 50);
        uislider1.minimumValue = 1;
        uislider1.maximumValue = ids.count;
        uislider1.value = idx + 1;
        [uislider1 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        UIButton *button1 = [[UIButton alloc]init];
        button1.frame =CGRectMake(self.view.frame.size.width*0.8/2-80-30, 160, 60, 20);
        [button1 setTitle:@" 确 定 " forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button2 = [[UIButton alloc]init];
        button2.frame =CGRectMake(self.view.frame.size.width*0.8/2+80-30, 160, 60, 20);
        [button2 setTitle:@" 取 消 " forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
        
        [contentView addSubview:uilabel];
        [contentView addSubview:uislider];
        [contentView addSubview:uilabel1];
        [contentView addSubview:uislider1];
        [contentView addSubview:button1];
        [contentView addSubview:button2];
        
        settingPopTipView = [[CMPopTipView alloc] initWithCustomView:contentView];
        
        settingPopTipView.backgroundColor = [UIColor darkGrayColor];
        settingPopTipView.textColor =[UIColor blueColor];
        settingPopTipView.delegate = self;
    }
    uilabel.text =[[NSString alloc]initWithFormat:@"亮度调节 ( %.1f )",currentBrightness];
    uislider.value = currentBrightness;
    uilabel1.text =[[NSString alloc]initWithFormat:@"快速跳转 ( %d / %d )",(idx+1),(int)ids.count];
    
    [settingPopTipView presentPointingAtBarButtonItem:btnSetting animated:YES];
    self.showed =true;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    //    NSLog(@"slider value = %f", sender.value);
    if(sender == self.uislider){
        float v =(int)(sender.value*10.0)/10.0;
        [sender setValue:v animated:NO];
        uilabel.text = [[NSString alloc] initWithFormat:@"亮度调节 ( %.1f )",v];
        [[UIScreen mainScreen] setBrightness:sender.value];
    }else if (sender == self.uislider1){
        int v =(int)(sender.value)/1.0;
        [sender setValue:v animated:NO];
        uilabel1.text = [[NSString alloc] initWithFormat:@"快速跳转 ( %d / %d )",v, (int)ids.count];
        idx = v  - 1;
        self.uid =[[ids objectAtIndex:idx] intValue]  ;
        [self refreshUI];
    }
}


-(void)nav
{
    
    [self performSegueWithIdentifier:@"showAuthorSegue" sender:self.poem];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAuthorSegue"])
    {
        XYAuthorViewController *vc = [segue destinationViewController];
        vc.uid = ((XYPoem *)sender).author_id;
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
    [self.tabBarController.tabBar setHidden:YES];
    
    //    NSLog(@"1##%@-%@-%@-%@",NSStringFromCGRect(self.tvContent.frame),NSStringFromCGSize(self.tvContent.contentSize) , NSStringFromUIEdgeInsets(self.tvContent.scrollIndicatorInsets),NSStringFromUIEdgeInsets(self.tvContent.contentInset));
}


-(void) viewWillDisappear:(BOOL)animated{
    //    [[self rdv_tabBarController] setTabBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

@end
