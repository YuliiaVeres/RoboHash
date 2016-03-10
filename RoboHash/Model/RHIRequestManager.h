//
//  RHIRequestManager.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/10/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHIRequestManager : NSObject

+ (instancetype)sharedInstance;

- (void)obtainRobotImageForString:(NSString *)requestString withCompletion:(void(^)(UIImage *, NSString *))completion;

@end
