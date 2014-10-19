#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "XYPoemService.h"

@interface XYAuthorListViewController : UITableViewController<MJRefreshBaseViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *sectionTitles; // 每个分区的标题
    NSMutableArray *contentsArray; // 每行的内容
    MJRefreshFooterView *_footer;
    XYPoemService *service;
     NSMutableArray *data;

}

@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@property BOOL isEnd;
//@property int total;
@property int lastDynastyId;

@property(nonatomic,retain)UISegmentedControl *sc;
@property int selectedTab;

@end
