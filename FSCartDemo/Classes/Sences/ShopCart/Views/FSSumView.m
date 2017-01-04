//
//  FSSumView.m
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import "FSSumView.h"

@implementation FSSumView

+ (FSSumView *)initView
{
    FSSumView *view = [[UINib nibWithNibName:NSStringFromClass([FSSumView class]) bundle:nil] instantiateWithOwner:self options:nil].lastObject;
    
    return view;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
