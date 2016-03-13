//
//  NSObject+BackgroundOperation.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/13/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BackgroundOperation)

- (void)executeOnBackground:(void (^)())block;

@end
