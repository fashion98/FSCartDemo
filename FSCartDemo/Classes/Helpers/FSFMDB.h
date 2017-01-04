//
//  FSFMDB.h
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSFMDB : NSObject

// 找到数据库路径（文件路径 xxx.sqlite）
+(void)findSQLWithPathComponent:(NSString *)pathComponentString;

// 创建表（goods表）
+(void)createTableWithSQL:(NSString *)sql andResultBlock:(void(^)(NSString *result))block;

// 增
+(void)insertWithSQL:(NSString *)sql andResultBlocck:(void(^)(BOOL result))block;

// 删
+(void)deleteWithSQL:(NSString *)sql andResultBlock:(void(^)(BOOL result))block;

// 改
+(void)updateWithSQL:(NSString *)sql andResultBlocck:(void (^)(BOOL result))block;

// 查单条
+(void)searchOneDataWithSQL:(NSString *)sql andResultBlock:(void (^)(BOOL result, NSDictionary *dict))block;

// 查全部
+(void)searchAllDataWithSQL:(NSString *)sql andResultBlock:(void (^)(BOOL success, NSMutableArray *goodList))block;


@end
