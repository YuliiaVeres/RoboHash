//
//  RHIRoboHash.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/19/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIRoboHash.h"

@implementation RHIRoboHash

+ (instancetype)createRoboHashInContext:(NSManagedObjectContext *)context withImageData:(NSData *)imageData title:(NSString *)title requestTime:(NSTimeInterval)requestTime
{
    RHIRoboHash *roboHash = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
    roboHash.title = title;
    roboHash.image = imageData;
    roboHash.requestTime = @(requestTime);
    
    return roboHash;
}

@end
