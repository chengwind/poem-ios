#import "XYDBManager.h"
#import "XYEntity.h"

@interface XYBaseDao : NSObject {
    FMDatabase * _db;
}


- (void) create:(XYEntity *) entity;

- (void) update:(XYEntity *) entity;

- (void) del:(int *) uid;

- (XYEntity *) get:(int *) uid;

- (NSArray *) get:(int *) uid limit:(int) limit;

@end
