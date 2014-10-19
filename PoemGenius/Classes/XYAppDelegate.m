#import "XYAppDelegate.h"
#import "XYOftenViewController.h"
#import "XYCategoryViewController.h"
#import "XYSearchViewController.h"
#import "XYAuthorListViewController.h"
#import "XYFavViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialTencentWeiboHandler.h"

@implementation XYAppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    self.window.backgroundColor = [UIColor whiteColor];
    //    [self setupViewControllers];
    //    [self.window makeKeyAndVisible];
    [UMSocialData setAppKey:UMENG_APPKEY];
    [UMSocialWechatHandler setWXAppId:@"wxd9a39c7122aa6516" appSecret:UMENG_APPKEY url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:UMENG_APPKEY url:@"http://www.umeng.com/social"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - Methods



@end
