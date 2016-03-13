//
//  NSObject+BackgroundOperation.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/13/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "NSObject+BackgroundOperation.h"

@implementation NSObject (BackgroundOperation)

- (void)executeOnBackground:(void (^)())block
{
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 1;
    
    NSBlockOperation *blockOperation = [NSBlockOperation new];
    __weak typeof(blockOperation)weakOperation = blockOperation;
    
    [blockOperation addExecutionBlock:^{
        
        typeof(weakOperation)strongOperation = weakOperation;
        
        NSLog(@"Queue: %@", queue);
        
        if (!strongOperation.isCancelled && block)
            block();
    }];
    
    [queue addOperation:blockOperation];
}

@end
