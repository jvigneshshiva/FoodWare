//
//  UIView+IBInspectableElements.m
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//

#import "UIView+IBInspectableElements.h"

@implementation UIView (IBInspectableElements)

-(void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

-(UIColor *)borderColor
{
    return [[UIColor alloc]initWithCGColor:self.layer.borderColor];
}

-(CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

@end
