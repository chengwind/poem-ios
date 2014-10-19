
#import "XYEntity.h"

@interface XYAuthor : XYEntity

@property (nonatomic, assign) int dynasty_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *name_py_abbr;
@property (nonatomic, strong) NSString *name_py_full;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, assign) int poem_num;
@property (nonatomic, strong) NSString *is_fav;

@property (nonatomic, strong) NSString *dynasty_name;

@end
