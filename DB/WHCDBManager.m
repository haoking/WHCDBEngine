//
//  DBManager.m
//  Logger
//
//  Created by 王浩臣 on 15/4/10.
//  Copyright (c) 2015年 王浩臣. All rights reserved.
//

#import "WHCDBManager.h"


@interface WHCDBManager()
{
    NSString *databasePath;
}

@property (nonatomic, assign) sqlite3 *logDB;


@end

static WHCDBManager *shareWHCDBManager = nil;

@implementation WHCDBManager

+(WHCDBManager *)shareWHCDBManagerInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareWHCDBManager = [[WHCDBManager alloc] init];
    });
    return shareWHCDBManager;
}

- (void)createLogDB
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"log.db"];
    databasePath = fileName;
    int result = sqlite3_open([fileName UTF8String], &_logDB);
    if (result == SQLITE_OK)
    {
        NSLog(@"##################成功打开数据库##################");
    }
    else
    {
        NSLog(@"打开数据库失败");
    }
}

-(BOOL)tableCreateWithSQL:(NSString *)sql
{

    [self createLogDB];
    char *errmsg = NULL;
    int result = sqlite3_exec(self.logDB, [sql UTF8String], NULL, NULL, &errmsg);
    if (result == SQLITE_OK)
    {
        NSLog(@"建表成功或者表已存在");
        return YES;
    }
    else
    {
        NSLog(@"建表失败--%s", errmsg);
        return NO;
    }
}
-(BOOL)insertWithSQL:(NSString *)sql
{
    char *errmsg = NULL;

    sqlite3_open([databasePath UTF8String], &_logDB);

    int result = sqlite3_exec(self.logDB, [sql UTF8String], NULL, NULL, &errmsg);
    if (result == SQLITE_OK)
    {
        NSLog(@"插入成功");
        return YES;
    }
    else
    {
        NSLog(@"插入失败--%s", errmsg);
        return NO;
    }
}
-(BOOL)deleteWithSQL:(NSString *)sql
{
    sqlite3_open([databasePath UTF8String], &_logDB);

    char *errmsg = NULL;
    int result = sqlite3_exec(self.logDB, [sql UTF8String], NULL, NULL, &errmsg);
    if (result == SQLITE_OK)
    {
        NSLog(@"删除成功");
        return YES;
    }
    else
    {
        NSLog(@"删除失败--%s", errmsg);
        return NO;
    }
}
-(BOOL)updateWithSQL:(NSString *)sql
{
    sqlite3_open([databasePath UTF8String], &_logDB);

    char *errmsg = NULL;
    int result = sqlite3_exec(self.logDB, [sql UTF8String], NULL, NULL, &errmsg);
    if (result == SQLITE_OK)
    {
        NSLog(@"更新成功");
        return YES;
    }
    else
    {
        NSLog(@"更新失败--%s", errmsg);
        return NO;
    }
}
-(void)selectWithSQL:(NSString *)sql withSuccessBlock:(didWithSuccessSelect)selectSuccess withFailBlock:(didWithfailSelect)selectFail
{
    self.selectSuccess = selectSuccess;
    self.selectFail = selectFail;
    sqlite3_open([databasePath UTF8String], &_logDB);

    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(self.logDB, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK)
    {
        if (_selectSuccess)
        {
            NSLog(@"查询语句没有问题");
            _selectSuccess(stmt);
        }
    }
    else
    {
        if(_selectFail)
        {
            NSLog(@"查询语句有问题");
            _selectFail();
        }
    }
}

-(sqlite3_stmt *)selectWithSQL:(NSString *)sql
{
    sqlite3_open([databasePath UTF8String], &_logDB);

    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(self.logDB, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK)
    {
        return stmt;
    }
    else
    {
        return stmt;
    }
}

-(void)close
{
    sqlite3_open([databasePath UTF8String], &_logDB);
    sqlite3_close(self.logDB);
    NSLog(@"##################关闭数据库成功##################");
}


@end
