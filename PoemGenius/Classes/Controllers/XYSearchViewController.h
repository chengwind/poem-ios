#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
#import "XYPoemService.h"
#import "MJRefresh.h"

@interface XYSearchViewController : UITableViewController<UISearchBarDelegate,CMPopTipViewDelegate,MJRefreshBaseViewDelegate>
{
    CMPopTipView *settingPopTipView;
    XYPoemService *service;
    MJRefreshFooterView *_footer;
}

@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain)NSMutableArray *data;
@property(nonatomic,retain) IBOutlet UILabel *uilabel;
@property(nonatomic,retain) IBOutlet UILabel *uilabel1;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *progress;


@property(nonatomic,strong)UIPickerView *myPicker;
@property(nonatomic,strong)UIActionSheet *actionSheet;
@property BOOL isEnd;



@end
