//
//  FSMeVC.m
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import "UIImage+ImageContentWithColor.h"

@implementation UIImage (ImageContentWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    //绘制图片
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];//把颜色设置为要填充的
    UIRectFill(rect);//真正的绘制
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
