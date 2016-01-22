//
//  UIView+IBInspectableElements.h
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//


#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIView (IBInspectableElements)

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;



@end
