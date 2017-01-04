//
//  FSShopCartCell.m
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import "FSShopCartCell.h"

@implementation FSShopCartCell

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
    
    self.goodsImgView.image = [UIImage imageNamed:model.goodsImg];
    self.goodsNameLabel.text = model.goodsName;
    
    self.goodsSizeLabel.text = model.goodsSeries;
    
    self.goodsNumLabel.text = [NSString stringWithFormat:@"%d", model.goodsNum];
    
    self.goodsPieceLabel.text = [NSString stringWithFormat:@"小计（共%d件）:", [self.goodsNumLabel.text intValue]];
    
    if ([self.goodsNumLabel.text intValue] < 5)
    {
        self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.goodsPrice];
        
        NSString *s = [self.goodsPriceLabel.text substringFromIndex:1];
                
        double a = [self.goodsNumLabel.text intValue]*[s doubleValue];
        
        self.goodsTotalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",a];
        
        self.goodsGroupPriceLabel.hidden = YES;
        self.goodsGroupLineView.hidden = YES;
        
        self.goodsGroupImgView.hidden = YES;
        self.goodsGroupWordLabel.hidden = YES;
    }
    else
    {
        self.goodsPriceLabel.text = [NSString stringWithFormat:@"%.2f", [model.goodsPrice intValue] * 0.8];
        
        self.goodsGroupPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.goodsPrice];
        
        double b = [self.goodsNumLabel.text intValue]*[self.goodsPriceLabel.text doubleValue];
        
        self.goodsTotalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",b];
        
        self.goodsGroupPriceLabel.hidden = NO;
        self.goodsGroupLineView.hidden = NO;
        
        self.goodsGroupImgView.hidden = NO;
        self.goodsGroupWordLabel.hidden = NO;
    }
    
    // 把每个cell的选中状态，通过bool值来确定，isSelected在外部进行改变
    self.cellSelectButton.selected = self.isSelected;
    
}




- (IBAction)cellSelectAction:(UIButton *)sender
{
    // 只要点击，改变状态，相反
    sender.selected = !sender.selected;
    
    if (self.cellBlock)
    {
        self.cellBlock(sender.selected);
    }
}


- (IBAction)cutNumAction:(UIButton *)sender
{
    if (self.cutNumBlock)
    {
        self.cutNumBlock(self.goodsNumLabel);
    }
    
}


- (IBAction)addNumAction:(UIButton *)sender
{
    if (self.addNumBlock)
    {
        self.addNumBlock(self.goodsNumLabel);
    }
    
}


- (IBAction)deleteGoodsAction:(UIButton *)sender
{
    if (self.deleteBlock)
    {
        self.deleteBlock(self.model);
    }
}













- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
