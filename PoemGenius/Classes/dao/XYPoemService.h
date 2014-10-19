#import "XYDBManager.h"
#import "XYBaseDao.h"
#import "XYPoem.h"
#import "XYAuthor.h"

@interface XYPoemService : XYBaseDao

- (NSMutableArray *) getCategories:(NSString *) catType;

- (NSMutableArray *) getAuthors:(NSString*)isFav limit:(int) limit offset:(int) offset;

- (NSMutableArray *) searchAuthors:(NSString*)dynasty_name searchText:(NSString*)searchText limit:(int) limit offset:(int) offset;

- (NSMutableArray *) searchAuthorsSort:(NSString*)searchText limit:(int) limit offset:(int) offset;

- (XYAuthor *) getAuthor:(int) uid;

- (NSMutableArray *) getPoems:(NSString*)searchText catType:(NSString *) catType catName:(NSString *) catName limit:(int) limit offset:(int) offset;

- (NSMutableArray *) getPoems:(NSString*)searchText catId:(int) catId limit:(int) limit offset:(int) offset;

- (NSMutableArray *) searchPoems:(int) searchType searchText:(NSString *) searchText limit:(int) limit offset:(int) offset;

- (NSMutableArray *) getFavPoems:(NSString *) isFav limit:(int) limit offset:(int) offset;

- (NSMutableArray *) getFavPoemsAuthors:(NSString *) isFav limit:(int) limit offset:(int) offset;

- (XYPoem *) getPoem:(int) uid;

- (BOOL) updatePoem:(int) poemId isFav:(NSString*) isFav;

- (BOOL) updatePoemByAuthor:(NSString *) authorName isFav:(NSString*) isFav;

- (BOOL) updateAuthor:(int) authorId isFav:(NSString*) isFav;

@end
