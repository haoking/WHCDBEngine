//
//  WHCDBEngine.m
//  ServiceFusionCRUD
//
//  Created by Haochen Wang on 12/9/16.
//  Copyright © 2016 WHC. All rights reserved.
//

#import "WHCDBEngine.h"
#import "WHCOperation.h"
#import "WHCDBManager.h"
#import "UserData.h"

@interface WHCDBEngine ()

@property (nonatomic, strong) WHCOperation *dbOPeration;
@property (nonatomic, strong) WHCOperationPool *dbPool;

@end

@implementation WHCDBEngine

SINGLETON_implementation(WHCDBEngine)

-(id)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }

    self.dbPool = [WHCOperationPool poolCreateWithSync];

    [WHCOperation operationCreateWithBlock:^{

        WHCDBManager *dbManager = [WHCDBManager shareWHCDBManagerInstance];

        NSString *sql = @"CREATE TABLE IF NOT EXISTS t_log (_id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT, lastName TEXT, phone TEXT, birth TEXT, zip TEXT);";
        [dbManager tableCreateWithSQL:sql];

    }inPool:self.dbPool];

    return self;
}

-(void)addUserWithFirstName:(NSString *)firstName
               withLastName:(NSString *)lastName
                  withPhone:(NSString *)phone
                  withBirth:(NSString *)birth
                    withZip:(NSString *)zip
{

    [WHCOperation operationCreateWithBlock:^{

        WHCDBManager *dbManager = [WHCDBManager shareWHCDBManagerInstance];
        NSString *sql=[NSString stringWithFormat:@"INSERT INTO t_log (firstName,lastName,phone,birth,zip) VALUES ('%@','%@','%@','%@','%@');",firstName, lastName, phone, birth, zip];
        [dbManager insertWithSQL:sql];
        [dbManager close];

    }inPool:self.dbPool];

}

-(void)selectUserWithFirstName:(NSString *)firstName withSuccess:(didWithSuccessSelectBlock)successBlock withFail:(didWithFailSelectBlock)failBlock
{
//    self.selectSuccessBlock = successBlock;
//    self.selectFailBlock = failBlock;

    [WHCOperation operationCreateWithBlock:^{

        WHCDBManager *dbManager = [WHCDBManager shareWHCDBManagerInstance];

        NSString *sql=[NSString stringWithFormat:@"SELECT _id,firstName,lastName,phone,birth,zip FROM t_log where firstName='%@';", firstName];

        [dbManager selectWithSQL:sql withSuccessBlock:^(sqlite3_stmt *stmt){

            NSMutableArray *userArray = [NSMutableArray array];
            while (sqlite3_step(stmt)==SQLITE_ROW)
            {
                int ID=sqlite3_column_int(stmt, 0);
                NSString *firstNameResult = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 1)];
                NSString *lastNameResult = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 2)];
                NSString *phoneResult = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 3)];
                NSString *birthResult = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 4)];
                NSString *zipResult = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 5)];

                UserData *userData = [UserData userDataCreate];
                userData.ID = ID;
                userData.firstName = firstNameResult;
                userData.lastName = lastNameResult;
                userData.phone = phoneResult;
                userData.birth = birthResult;
                userData.zip = zipResult;

                [userArray addObject:userData];
            }
            [dbManager close];
            if (successBlock)
            {
                successBlock(userArray);
            }
            
        } withFailBlock:^{
            
            [dbManager close];
            if (failBlock)
            {
                failBlock();
            }
        }];

    }inPool:self.dbPool];


}

-(void)deleteUserWithID:(int)ID
{
    [WHCOperation operationCreateWithBlock:^{

        WHCDBManager *dbManager = [WHCDBManager shareWHCDBManagerInstance];

        NSString *sql=[NSString stringWithFormat:@"DELETE FROM t_log WHERE (_id=%d);", ID];
        [dbManager deleteWithSQL:sql];
        [dbManager close];

    }inPool:self.dbPool];

}

-(void)updateUserWithID:(int)ID
              firstName:(NSString *)firstName
           withLastName:(NSString *)lastName
              withPhone:(NSString *)phone
              withBirth:(NSString *)birth
                withZip:(NSString *)zip
{
    [WHCOperation operationCreateWithBlock:^{

        WHCDBManager *dbManager = [WHCDBManager shareWHCDBManagerInstance];
        NSMutableString *sql = [NSMutableString stringWithString:@"UPDATE t_log SET "];
        if (![firstName isEqualToString:@""])
        {
            [sql appendFormat:@"firstName = '%@',", firstName];
        }

        if (![firstName isEqualToString:@""])
        {
            [sql appendFormat:@"lastName = '%@',", lastName];
        }

        if (![firstName isEqualToString:@""])
        {
            [sql appendFormat:@"phone = '%@',", phone];
        }

        if (![firstName isEqualToString:@""])
        {
            [sql appendFormat:@"birth = '%@',", birth];
        }

        if (![firstName isEqualToString:@""])
        {
            [sql appendFormat:@"zip = '%@',", zip];
        }

        [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
        [sql appendFormat:@" WHERE (_id=%d)", ID];
        [dbManager updateWithSQL:sql];
        [dbManager close];

    }inPool:self.dbPool];
}





@end










