//
//  FSGoods.h
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSGoods : NSObject

@property (assign, nonatomic) NSString *goodsId;

@property (strong, nonatomic) NSString *goodsImg;

@property (strong, nonatomic) NSString *goodsName;

@property (strong, nonatomic) NSString *goodsPrice;

@property (strong, nonatomic) NSString *goodsSeries;

@property (assign, nonatomic) int goodsNum;

@end
