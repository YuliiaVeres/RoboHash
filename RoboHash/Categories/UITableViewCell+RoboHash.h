//
//  UITableViewCell+RoboHash.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/19/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHIRoboHash.h"

@interface UITableViewCell (RoboHash)

- (void)configureCellWithRoboHash:(RHIRoboHash *)roboHash;

@end
