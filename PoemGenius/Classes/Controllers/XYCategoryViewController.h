#import <UIKit/UIKit.h>
#import "XYPoemService.h"

@interface XYCategoryViewController : UITableViewController
{
    XYPoemService *service;
}


@property(nonatomic,retain)NSMutableArray *data;
@property(nonatomic,strong)IBOutlet UISegmentedControl *sc;
@property(nonatomic,strong)NSString *catType;
@end
