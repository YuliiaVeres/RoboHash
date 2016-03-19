//
//  RHIRequestManager.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/10/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RHIRequestType) {
    RHIRequestTypeUser,
    RHIRequestTypeRandom
};

@interface RHIRequestManager : NSObject

- (void)obtainRobotImageForString:(NSString *)requestString withCompletion:(void(^)(NSData *, NSString *))completion;
- (void)downloadRobotImageForString:(NSString *)requestString handler:(void(^)(NSURL *))handler;

@end
