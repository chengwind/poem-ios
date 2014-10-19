//
//  SDBManager.h
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseAdditions.h"

@class FMDatabase;

@interface XYDBManager : NSObject {
    NSString * _name;
}

@property (nonatomic, readonly) FMDatabase * dataBase;

+(XYDBManager *) defaultDBManager;


- (void) close;

@end
