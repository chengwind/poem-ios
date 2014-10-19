#import <UIKit/UIKit.h>

@interface XYSettingViewController : UITableViewController<UISearchBarDelegate>
{
}

@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain)NSMutableArray *data;

@end
