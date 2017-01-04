//
//  FSShopCartCell.h
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSGoods.h"

typedef void(^ShopCartSelectCellBlock)(BOOL cellSelected);

typedef void(^ShopCartNumBlock)(UILabel *numLabel);//加减block

typedef void(^DeleteBlock)(FSGoods *good);

@interface FSShopCartCell : UITableViewCell

@property (assign ,nonatomic) BOOL isSelected;

@property (weak, nonatomic) IBOutlet UIButton *cellSelectButton;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsGroupPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *goodsGroupLineView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *goodsGroupImgView;

@property (weak, nonatomic) IBOutlet UILabel *goodsGroupWordLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsPieceLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsTotalPriceLabel;

@property (copy, nonatomic) ShopCartSelectCellBlock cellBlock;

@property (copy, nonatomic) ShopCartNumBlock cutNumBlock;

@property (copy, nonatomic) ShopCartNumBlock addNumBlock;

@property (copy, nonatomic) DeleteBlock deleteBlock;

@property (strong, nonatomic) FSGoods *model;

@end
