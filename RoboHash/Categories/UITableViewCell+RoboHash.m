//
//  UITableViewCell+RoboHash.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/19/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "UITableViewCell+RoboHash.h"

@implementation UITableViewCell (RoboHash)

- (void)configureCellWithRoboHash:(RHIRoboHash *)roboHash
{
    self.textLabel.text = roboHash.title;
    self.imageView.image = [UIImage imageWithData:roboHash.image];
}

@end
