
#import "XYBaseDao.h"

#define kUserTableName @"poem"

@implementation XYBaseDao

- (id) init {
    self = [super init];
    if (self) {
        _db = [XYDBManager defaultDBManager].dataBase;
        
    }
    return self;
}

- (void) create:(XYEntity *) entity{
    return;
}

- (void) update:(XYEntity *) entity{
    return;
}

- (void) del:(int *) uid{
    [_db executeUpdate:@"DELETE FROM Entity WHERE id = ?",*uid];
    return;
}

- (XYEntity *) get:(int *) uid{
    NSString * query = @"SELECT id FROM Entity";
    query = [query stringByAppendingFormat:@" WHERE id = %d",*uid];
    FMResultSet * rs = [_db executeQuery:query];
    XYEntity * entity = [XYEntity new];
    if ([rs next]) {
        entity.uid = [rs intForColumn:@"id"];
    }
    [rs close];
    return entity;
}

- (NSArray *) get:(int *) uid limit:(int ) limit{
    NSString * query = @"SELECT id FROM Entity";
    if (!uid) {
        query = [query stringByAppendingFormat:@" ORDER BY id DESC limit %d",limit];
    } else {
        query = [query stringByAppendingFormat:@" WHERE id > %d ORDER BY id DESC limit %d",*uid,limit];
    }
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        XYEntity * entity = [XYEntity new];
        entity.uid = [rs intForColumn:@"id"];
        [array addObject:entity];
    }
    [rs close];
    return array;
}

@end
