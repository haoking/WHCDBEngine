//
//  WHCDBEngine.h
//  ServiceFusionCRUD
//
//  Created by Haochen Wang on 12/9/16.
//  Copyright © 2016 WHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHCConstants.h"

typedef void (^didWithSuccessSelectBlock)(NSMutableArray *resultArray);
typedef void (^didWithFailSelectBlock)();

@interface WHCDBEngine : NSObject

    //select成功时的回调
@property (nonatomic, copy) didWithSuccessSelectBlock selectSuccessBlock;
@property (nonatomic, copy) didWithFailSelectBlock selectFailBlock;

SINGLETON_interface(WHCDBEngine)

-(void)addUserWithFirstName:(NSString *)firstName
               withLastName:(NSString *)lastName
                  withPhone:(NSString *)phone
                  withBirth:(NSString *)birth
                    withZip:(NSString *)zip;

-(void)selectUserWithFirstName:(NSString *)firstName withSuccess:(didWithSuccessSelectBlock)successBlock withFail:(didWithFailSelectBlock)failBlock;

-(void)deleteUserWithID:(int)ID;

-(void)updateUserWithID:(int)ID
              firstName:(NSString *)firstName
           withLastName:(NSString *)lastName
              withPhone:(NSString *)phone
              withBirth:(NSString *)birth
                withZip:(NSString *)zip;

@end
