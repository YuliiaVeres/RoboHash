//
//  UINavigationBar+RoboHash.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/18/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "UINavigationBar+RoboHash.h"

@implementation UINavigationBar (RoboHash)

- (void)transparentBar
{
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [UIImage new];
}

@end
