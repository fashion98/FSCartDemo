//
//  FSGoodsCollectionCell.h
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSGoods.h"

typedef void(^BuyBlock)(FSGoods *model);
@interface FSGoodsCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) FSGoods *model;

@property (copy, nonatomic) BuyBlock buyBlock;

@end
