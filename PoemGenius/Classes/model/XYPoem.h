
#import "XYEntity.h"

@interface XYPoem : XYEntity

@property (nonatomic, assign) int author_id;
@property (nonatomic, assign) int genre_id;
@property (nonatomic, assign) int rhythm_id;
@property (nonatomic, assign) int dynasty_id;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *title_note;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *word_notes;
@property (nonatomic, strong) NSString *is_fav;
@property (nonatomic, strong) NSString *is_read;
@property (nonatomic, strong) NSString *update_time;

@property (nonatomic, strong) NSString *author_name;
@property (nonatomic, strong) NSString *genre_name;
@property (nonatomic, strong) NSString *rhythm_name;
@property (nonatomic, strong) NSString *dynasty_name;

@end
