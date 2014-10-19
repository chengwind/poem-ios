//
//  SDBManager.m
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "XYDBManager.h"
#import "FMDatabase.h"
#import "ZipArchive.h"

#define kDefaultDBName @"poem.db"

@interface XYDBManager ()

@end

@implementation XYDBManager

static XYDBManager * _sharedDBManager;

+ (XYDBManager *) defaultDBManager {
	if (!_sharedDBManager) {
		_sharedDBManager = [[XYDBManager alloc] init];
	}
	return _sharedDBManager;
}

- (void) dealloc {
    [self close];
}

- (id) init {
    self = [super init];
    if (self) {
        [self connect:kDefaultDBName];
    }
    return self;
}

- (void) connect:(NSString *) name{
	if (!_dataBase) {
        NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        _name = [documentsDir stringByAppendingPathComponent: name];
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isExist = [fm fileExistsAtPath:_name];
        NSLog(@"File = %@, %d",_name ,isExist);
        if (!isExist)
        {
            
            NSString* zipFile = [[NSBundle mainBundle]
                                 pathForResource:@"p"
                                 ofType:@"dll"];
            [self unzip:zipFile];
            BOOL isExists2=[fm fileExistsAtPath:_name];
            NSLog(@"isExist2 =%d",[fm fileExistsAtPath:_name]);
            if(isExists2){
                [self deleteFile:zipFile];
            }
        }
		_dataBase = [FMDatabase databaseWithPath:_name];
	}
	if (![_dataBase open]) {
		NSLog(@"cannot open database");
	}
}

- (void)unzip:(NSString*)zipFile{
    ZipArchive* zip = [[ZipArchive alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dcoumentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* unzipto = dcoumentpath ;
    if( [zip UnzipOpenFile:zipFile] ) {
        BOOL ret = [zip UnzipFileTo:unzipto overWrite:YES];
        NSLog(@"l_zipfile =%@ , %@ , %hhd",zipFile ,unzipto, ret);
        if( NO==ret ) { }
        [zip UnzipCloseFile];
    }
}


-(void)deleteFile:(NSString*)filePath
{
    NSFileManager* fileMngr = [NSFileManager defaultManager];
    if ([fileMngr fileExistsAtPath:filePath]) {
        NSError* deletionError;
        bool isDeleted = [fileMngr removeItemAtPath:filePath error:&deletionError];
        if (isDeleted) {
            NSLog(@"file Deleted");
        }else {
            NSLog(@"Deleting Error : %@",[deletionError localizedDescription]);
        }
        deletionError = nil;
    }
    fileMngr = nil;
}


- (void) close {
	[_dataBase close];
    _sharedDBManager = nil;
}

@end
