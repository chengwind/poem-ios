
#import "XYPoemService.h"
#import "XYPoem.h"
#import "XYCategory.h"
#import "XYAuthor.h"


@implementation XYPoemService

- (id) init {
    self = [super init];
    return self;
}

- (NSMutableArray *) getCategories:(NSString *) catType{
    NSString * query = @"SELECT * FROM category";
    query = [query stringByAppendingFormat:@" WHERE cat_type ='%@' order by seq_num desc,name ",catType];
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        XYCategory * entity = [self wrapCategory:rs];
        
        [array addObject:entity];
    }
    [rs close];
    return array;
}

- (XYCategory *) wrapCategory:(FMResultSet *) rs{
    XYCategory * entity = [XYCategory new];
    entity.uid = [rs intForColumn:@"id"];
    entity.name = [rs stringForColumn:@"name"];
    entity.cat_type = [rs stringForColumn:@"cat_type"];
    entity.poem_num = [rs intForColumn:@"poem_num"];
    entity.author_num = [rs intForColumn:@"author_num"];
    entity.seq_num = [rs intForColumn:@"seq_num"];
    return entity;
}

- (NSMutableArray *) getAuthors:(NSString*)isFav limit:(int) limit offset:(int) offset{
    NSString * query = @" SELECT a.id,a.dynasty_name,a.name,a.is_fav,a.poem_num,b.id as dynasty_id FROM author a left join category b on a.dynasty_name = b.name ";
    if ([isFav isEqual:@"0"] || [isFav isEqual:@"1"]) {
        query = [query stringByAppendingFormat:@" where a.is_fav='%@' limit %d offset %d ",isFav,limit,offset];
    }else{
        query = [query stringByAppendingFormat:@" limit %d offset %d ",limit,offset];
    }
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        XYAuthor * entity = [self wrapAuthor:rs];
        entity.dynasty_id= [rs intForColumn:@"dynasty_id"];
        [array addObject:entity];
    }
    [rs close];
    return array;
}

- (NSMutableArray *) searchAuthors:(NSString*)dynasty_name searchText:(NSString*)searchText limit:(int) limit offset:(int) offset{
    searchText = [self replaceStr: searchText];
    NSString * query = @" SELECT a.id,a.dynasty_name,a.name,a.is_fav,a.poem_num,b.id as dynasty_id FROM author a left join category b on a.dynasty_name = b.name where 1=1 ";
    if(dynasty_name!=nil && ![dynasty_name isEqual:@""]){
        query = [query stringByAppendingFormat:@"  and ( a.dynasty_name='%@' ) ",dynasty_name];
    }
    if(searchText!=nil && ![searchText isEqual:@""]){
        query = [query stringByAppendingFormat:@"  and ( a.name like '%@%%' or a.name_py_full like '%@%%' or a.name_py_abbr like '%@%%') ",searchText,searchText,searchText];
    }
    
    query = [query stringByAppendingFormat:@" limit %d offset %d ",limit,offset];
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        XYAuthor * entity = [self wrapAuthor:rs];
        entity.dynasty_id= [rs intForColumn:@"dynasty_id"];
        [array addObject:entity];
    }
    [rs close];
    return array;
}

- (NSMutableArray *) searchAuthorsSort:(NSString*)searchText limit:(int) limit offset:(int) offset{
        searchText = [self replaceStr: searchText];
        NSString * query = @" SELECT a.id,a.dynasty_name,a.name,a.is_fav,a.poem_num,b.id as dynasty_id FROM author a left join category b on a.dynasty_name = b.name where 1=1 ";
        if(searchText!=nil && ![searchText isEqual:@""]){
            query = [query stringByAppendingFormat:@"  and ( a.name like '%@%%' or a.name_py_full like '%@%%' or a.name_py_abbr like '%@%%') ",searchText,searchText,searchText];
        }
        
        query = [query stringByAppendingFormat:@" order by b.seq_num desc,a.name_py_full limit %d offset %d ",limit,offset];
        FMResultSet * rs = [_db executeQuery:query];
        NSMutableArray *array = [NSMutableArray array];
        while ([rs next]) {
            XYAuthor * entity = [self wrapAuthor:rs];
            entity.dynasty_id= [rs intForColumn:@"dynasty_id"];
            [array addObject:entity];
        }
        [rs close];
        return array;
}

- (XYAuthor *) getAuthor:(int) uid{
    NSString * query = @" SELECT a.* FROM author a ";
    query = [query stringByAppendingFormat:@" where a.id= %d ",uid];
    FMResultSet * rs = [_db executeQuery:query];
    XYAuthor *entity;
    if ([rs next]) {
        entity = [self wrapAuthor:rs];
        entity.name_py_abbr = [rs stringForColumn:@"name_py_abbr"];
        entity.name_py_full = [rs stringForColumn:@"name_py_full"];
        entity.des = [rs stringForColumn:@"des"];
    }
    [rs close];
    return entity;
}

- (XYAuthor *) wrapAuthor:(FMResultSet *) rs{
    XYAuthor *entity = [XYAuthor new];
    entity.uid = [rs intForColumn:@"id"];
    entity.name = [rs stringForColumn:@"name"];
    entity.poem_num = [rs intForColumn:@"poem_num"];
    entity.is_fav = [rs stringForColumn:@"is_fav"];
    entity.dynasty_name= [rs stringForColumn:@"dynasty_name"];
    return entity;
}

- (NSMutableArray *) getPoems:(NSString*)searchText catType:(NSString *) catType catName:(NSString *) catName limit:(int) limit offset:(int) offset{
    searchText = [self replaceStr: searchText];
    NSString * query = @"SELECT a.id,a.title,a.is_fav,a.is_read,a.author_name,a.dynasty_name,a.genre_name,a.rhythm_name FROM poem a ";
    if([catType isEqual:@"d"]){
        if(searchText==nil || [searchText isEqual:@""]){
            query = [query stringByAppendingFormat:@" WHERE a.dynasty_name='%@' limit %d offset %d ",catName ,limit,offset];
        }else{
            query = [query stringByAppendingFormat:@" WHERE a.title like '%%%@%%' and a.dynasty_name='%@' limit %d offset %d ",searchText,catName ,limit,offset];
        }
    }else if ([catType isEqual:@"g"]){
        if(searchText==nil || [searchText isEqual:@""]){
            query = [query stringByAppendingFormat:@" WHERE a.genre_name='%@'  limit %d offset %d ",catName ,limit,offset];
        }else{
            query = [query stringByAppendingFormat:@" WHERE a.title like '%%%@%%' and a.genre_name='%@' limit %d offset %d ",searchText,catName ,limit,offset];
        }
    }else if ([catType isEqual:@"r"]){
        if(searchText==nil || [searchText isEqual:@""]){
            query = [query stringByAppendingFormat:@" WHERE a.rhythm_name='%@' limit %d offset %d ",catName ,limit,offset];
        }else{
            query = [query stringByAppendingFormat:@" WHERE a.title like '%%%@%%' and a.rhythm_name='%@' limit %d offset %d ",searchText,catName ,limit,offset];
        }
        
    }else if ([catType isEqual:@"a"]){
        if(searchText==nil || [searchText isEqual:@""]){
            query = [query stringByAppendingFormat:@" WHERE a.author_name='%@'  order by a.is_fav desc,a.title limit %d offset %d ",catName ,limit,offset];
        }else{
            
            query = [query stringByAppendingFormat:@" WHERE a.title like '%%%@%%' and a.author_name='%@' order by a.is_fav desc,a.title limit %d offset %d ",searchText,catName ,limit,offset];
        }
    }else if ([catType isEqual:@"f"]){
        if(searchText==nil || [searchText isEqual:@""]){
            query = [query stringByAppendingFormat:@" WHERE a.author_name='%@' and a.is_fav='1' limit %d offset %d ",catName ,limit,offset];
        }else{
            
            query = [query stringByAppendingFormat:@" WHERE a.title like '%%%@%%' and a.is_fav='1' and a.author_name='%@' limit %d offset %d ",searchText,catName ,limit,offset];
        }
    }
    
    FMResultSet *rs = [_db executeQuery:query];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        XYPoem *entity = [self wrapPoem:rs];
        [array addObject:entity];
    }
    [rs close];
    return array;
}

- (NSMutableArray *) getPoems:(NSString*)searchText catId:(int) catId limit:(int) limit offset:(int) offset{
    searchText = [self replaceStr: searchText];
    NSString * query = @"SELECT a.id,a.title,a.is_fav,a.is_read,a.author_name,a.dynasty_name,a.genre_name,a.rhythm_name FROM category_poem b LEFT JOIN poem a ON b.poem_id = a.id  ";
    if(searchText==nil || [searchText isEqual:@""]){
        query = [query stringByAppendingFormat:@" WHERE category_id=%d limit %d offset %d ",catId ,limit, offset];
    }else{
        query = [query stringByAppendingFormat:@" WHERE a.title like '%%%@%%' and category_id=%d limit %d offset %d ",searchText, catId ,limit, offset];
    }
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        XYPoem *entity = [self wrapPoem:rs];
        [array addObject:entity];
    }
    [rs close];
    return array;
}

- (NSString *) replaceStr:(NSString *)txt{
    if(txt==nil || [txt isEqual:@""]){
        return txt;
    }
    txt= [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    txt = [txt stringByReplacingOccurrencesOfString:@"    " withString:@"%"];
    txt = [txt stringByReplacingOccurrencesOfString:@"   " withString:@"%"];
    txt = [txt stringByReplacingOccurrencesOfString:@"  " withString:@"%"];
    txt = [txt stringByReplacingOccurrencesOfString:@" " withString:@"%"];
    return txt;
}

- (NSMutableArray *) searchPoems:(int) searchType searchText:(NSString *) searchText limit:(int) limit offset:(int) offset{
    searchText = [self replaceStr: searchText];
    NSString * query= @"SELECT a.id,a.title,a.is_fav,a.is_read,a.author_name,a.dynasty_name,a.genre_name,a.rhythm_name FROM poem a ";
    if(searchType==0){
        query = [query stringByAppendingFormat:@" WHERE ( a.title like '%%%@%%' ) limit %d offset %d ",searchText,limit, offset];
    }else if(searchType==2){
        query = [query stringByAppendingFormat:@" WHERE ( a.content like '%%%@%%') limit %d offset %d ",searchText ,limit, offset];
    }else if(searchType==3){
        query = [query stringByAppendingFormat:@" WHERE ( a.comment like '%%%@%%') limit %d offset %d ",searchText ,limit, offset];
    }else if(searchType==1){
        query = [query stringByAppendingFormat:@" WHERE ( a.author_name like '%%%@%%') limit %d offset %d ",searchText ,limit, offset];
    }else{
        query = [query stringByAppendingFormat:@" WHERE ( a.title like '%%%@%%' or a.content like '%%%@%%' or a.comment like '%%%@%%' or a.author_name like '%%%@%%') limit %d offset %d ",searchText,searchText,searchText,searchText ,limit, offset];
    }
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        XYPoem *entity = [self wrapPoem:rs];
        [array addObject:entity];
    }
    [rs close];
    return array;
}


- (NSMutableArray *) getFavPoems:(NSString *) isFav limit:(int) limit offset:(int) offset{
    NSString * query = @"SELECT a.id,a.title,a.is_fav,a.is_read,a.author_name,a.dynasty_name,a.genre_name,a.rhythm_name FROM poem a ";
    
    query = [query stringByAppendingFormat:@" WHERE a.is_fav='%@' limit %d offset %d ",isFav ,limit, offset];
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        XYPoem *entity = [self wrapPoem:rs];
        [array addObject:entity];
    }
    [rs close];
    return array;
}

- (NSMutableArray *) getFavPoemsAuthors:(NSString *) isFav limit:(int) limit offset:(int) offset{
    NSString * query = @"SELECT a.id,a.dynasty_name,a.name,a.is_fav,count(1) as poem_num FROM poem p inner join author a on p.author_name=a.name ";
    
    query = [query stringByAppendingFormat:@" WHERE p.is_fav='%@' group by a.id,a.dynasty_name,a.name,a.is_fav limit %d offset %d ",isFav,limit, offset];
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        XYAuthor *entity = [self wrapAuthor:rs];
        [array addObject:entity];
    }
    [rs close];
    return array;
}

- (XYPoem *) getPoem:(int) uid{
    NSString * query = @"SELECT a.*,b.id as author_id FROM poem a left join author b on a.author_name = b.name ";
    
    query = [query stringByAppendingFormat:@" WHERE a.id='%d'",uid];
    
    FMResultSet * rs = [_db executeQuery:query];
    XYPoem *entity;
    if ([rs next]) {
        entity = [self wrapPoem:rs];
        
        entity.title_note = [rs stringForColumn:@"title_note"];
        entity.content = [rs stringForColumn:@"content"];
        entity.comment = [rs stringForColumn:@"comment"];
        entity.word_notes = [rs stringForColumn:@"word_notes"];
        entity.update_time = [rs stringForColumn:@"update_time"];
        entity.author_id = [rs intForColumn:@"author_id"];
    }
    [rs close];
    return entity;
}

- (XYPoem *) wrapPoem:(FMResultSet *) rs{
    XYPoem *entity = [XYPoem new];
    entity.uid = [rs intForColumn:@"id"];
    
    entity.title = [rs stringForColumn:@"title"];
    entity.is_fav = [rs stringForColumn:@"is_fav"];
    entity.is_read = [rs stringForColumn:@"is_read"];
    
    entity.author_name = [rs stringForColumn:@"author_name"];
    entity.genre_name = [rs stringForColumn:@"genre_name"];
    entity.dynasty_name = [rs stringForColumn:@"dynasty_name"];
    entity.rhythm_name = [rs stringForColumn:@"rhythm_name"];
    return entity;
}

- (BOOL) updatePoem:(int) poemId isFav:(NSString*) isFav{
    NSString * query =[[NSString alloc]initWithFormat:@"update poem set is_fav='%@' where id=%d",isFav,poemId];
    BOOL rtn = [_db executeUpdate:query];
    return rtn;
}

- (BOOL) updatePoemByAuthor:(NSString *) authorName isFav:(NSString*) isFav{
    NSString * query =[[NSString alloc]initWithFormat:@"update poem set is_fav='%@' where author_name='%@'",isFav,authorName];
    BOOL rtn = [_db executeUpdate:query];
    return rtn;
}

- (BOOL) updateAuthor:(int)authorId isFav:(NSString*)isFav{
    NSString * query =[[NSString alloc]initWithFormat:@"update author set is_fav='%@' where id=%d",isFav,authorId];
    BOOL rtn = [_db executeUpdate:query];
    return rtn;
}

@end
