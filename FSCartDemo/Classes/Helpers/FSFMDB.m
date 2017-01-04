//
//  FSFMDB.m
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import "FSFMDB.h"
#import <FMDB.h>
#import "FSGoods.h"

FMDatabase *db;

@implementation FSFMDB

+ (void)findSQLWithPathComponent:(NSString *)pathComponentString
{
    // pathComponentString = @"xxx.sqlite"
    NSString *path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:pathComponentString];
    
    // FMDB 创建数据库文件（创建xxx.sqlite文件）
    db = [FMDatabase databaseWithPath:path];
    NSLog(@"%@",path);
}

+ (void)createTableWithSQL:(NSString *)sql andResultBlock:(void (^)(NSString *))block
{
    NSString *rs;
    
    if ([db open])
    {
        if ([db executeUpdate:sql])
        {
            rs = @"建表成功";
        }
        else
        {
            rs = @"建表失败";
        }
        
        block(rs);
    }
}


+ (void)insertWithSQL:(NSString *)sql andResultBlocck:(void (^)(BOOL))block
{
    BOOL rs;
    
    if ([db open])
    {
        if ([db executeUpdate:sql])
        {
            rs = YES;
        }
        else
        {
            rs = NO;
        }
        
        block(rs);
    }
}


+ (void)deleteWithSQL:(NSString *)sql andResultBlock:(void (^)(BOOL))block
{
    BOOL rs;
    
    if ([db open])
    {
        if ([db executeUpdate:sql])
        {
            rs = YES;
        }
        else
        {
            rs = NO;
        }
        
        block(rs);
    }
}


+ (void)updateWithSQL:(NSString *)sql andResultBlocck:(void (^)(BOOL))block
{
    BOOL rs;
    
    if ([db open])
    {
        if ([db executeUpdate:sql])
        {
            rs = YES;
        }
        else
        {
            rs = NO;
        }
        
        block(rs);
    }
}


// 查询单条数据  是否存在
+ (void)searchOneDataWithSQL:(NSString *)sql andResultBlock:(void (^)(BOOL, NSDictionary *))block
{
    BOOL result =NO;
    
    //desc降序
    //asc升序
    //通过年龄排序
    //    NSString *sql=@"select *from CartGoodsList2 order by ID asc";
    
    
    if ([db open])
    {
        
        //把从数据库查询到的数据放到FMResultSet
        FMResultSet *set=[db executeQuery:sql];
        
        NSMutableDictionary *goodsDic=[NSMutableDictionary dictionary];
        //        CCLCeShiGoodsModel *goods = [CCLCeShiGoodsModel new];
        
        if ([set next])
        {
            result = YES;
            
            [goodsDic setObject:[set stringForColumn:@"goodsId"] forKey:@"goodsId"];
            [goodsDic setObject:[set stringForColumn:@"goodsImg"] forKey:@"goodsImg"];
            [goodsDic setObject:[set stringForColumn:@"goodsName"] forKey:@"goodsName"];
            [goodsDic setObject:[set stringForColumn:@"goodsSeries"] forKey:@"goodsSeries"];
            [goodsDic setObject:[set stringForColumn:@"goodsPrice"] forKey:@"goodsPrice"];
            [goodsDic setObject:@([set intForColumn:@"goodsNum"]) forKey:@"goodsNum"];
        }
        
        block(result,goodsDic);
        
        
    }
}


+ (void)searchAllDataWithSQL:(NSString *)sql andResultBlock:(void (^)(BOOL, NSMutableArray *))block
{
    BOOL success = NO;
    
    if ([db open]) {
        
        FMResultSet *resultSet = [db executeQuery:sql];
        
        NSMutableArray *list = [NSMutableArray array];
        
        while ([resultSet next])
        {
            
            success = YES;
            
            FSGoods *goods = [FSGoods new];
            
            goods.goodsId = [resultSet objectForColumnName:@"goodsId"];
            goods.goodsImg = [resultSet objectForColumnName:@"goodsImg"];
            goods.goodsName = [resultSet objectForColumnName:@"goodsName"];
            goods.goodsSeries = [resultSet objectForColumnName:@"goodsSeries"];
            goods.goodsPrice = [resultSet objectForColumnName:@"goodsPrice"];
            goods.goodsNum = [resultSet intForColumn:@"goodsNum"];
            
            [list addObject:goods];
        }
        
        block(success, list);
        
    }
}


@end
