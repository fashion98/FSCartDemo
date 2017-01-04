//
//  FSGoodsCollectionCell.m
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import "FSGoodsCollectionCell.h"

@implementation FSGoodsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(FSGoods *)model
{
    if (_model != model)
    {
        _model = nil;
        _model = model;
    }
    
    //    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:BASE_URL(@"%@"), model.goodsImg]] placeholderImage:[UIImage imageNamed:@"aa"]];
    self.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", model.goodsImg]];
    
    self.nameLabel.text = model.goodsName;
    
    self.sizeLabel.text = model.goodsSeries;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.goodsPrice];
    
    
    
}


// 点击立即购买
- (IBAction)buyAction:(UIButton *)sender {
    
    if (self.buyBlock) {
        
        self.buyBlock(self.model);
    }
}

@end
