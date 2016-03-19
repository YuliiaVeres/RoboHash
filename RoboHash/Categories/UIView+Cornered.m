//
//  UIView+Cornered.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/18/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "UIView+Cornered.h"

@implementation UIView (Cornered)

- (void)corneredWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    self.layer.cornerRadius = radius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

@end
