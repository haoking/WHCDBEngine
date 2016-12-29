//
//  DBManager.h
//  Logger
//
//  Created by 王浩臣 on 15/4/10.
//  Copyright (c) 2015年 王浩臣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


typedef void (^didWithSuccessSelect)(sqlite3_stmt *stmt);
typedef void (^didWithfailSelect)();

@interface WHCDBManager : NSObject

@property (nonatomic, copy) didWithSuccessSelect selectSuccess;
@property (nonatomic, copy) didWithfailSelect selectFail;

+(WHCDBManager *)shareWHCDBManagerInstance;


-(BOOL)tableCreateWithSQL:(NSString *)sql;
-(BOOL)insertWithSQL:(NSString *)sql;
-(BOOL)deleteWithSQL:(NSString *)sql;
-(BOOL)updateWithSQL:(NSString *)sql;
-(void)selectWithSQL:(NSString *)sql withSuccessBlock:(didWithSuccessSelect)selectSuccess withFailBlock:(didWithfailSelect)selectFail;
-(sqlite3_stmt *)selectWithSQL:(NSString *)sql;

-(void)close;

@end
