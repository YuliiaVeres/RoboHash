//
//  RHIHashHistoryStach.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/19/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIHashHistoryStack.h"
#import "RHIRoboHash.h"

@interface RHIHashHistoryStack ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation RHIHashHistoryStack

- (id)init
{
    if (self = [super init])
    {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _context.persistentStoreCoordinator = [[RHICoreDataManager sharedInstance] persistentStoreCoordinator];
        
        _operationQueue = [NSOperationQueue new];
        _operationQueue.name = @"HashHistoryStack's Queue";
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

- (void)saveRoboHashWithImageData:(NSData *)imageData title:(NSString *)title requestTime:(NSTimeInterval)requestTime
{
    NSBlockOperation *generateOperation = [NSBlockOperation new];
    __weak typeof(generateOperation) weakOperation = generateOperation;
    __weak typeof(self) weakSelf = self;
    
    [generateOperation addExecutionBlock:^{
        typeof(weakOperation) strongOperation = weakOperation;
        typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongOperation.isCancelled) {
            [strongSelf.context performBlockAndWait:^{
                
                [RHIRoboHash createRoboHashInContext:strongSelf.context withImageData:imageData title:title requestTime:requestTime];
                
                NSError *error;
                BOOL success = [strongSelf.context save:&error];
                
                if (!success) {
                    NSLog(@"ERROR saving RoboHash: %@", error.localizedDescription);
                }
                
                NSLog(@"\n\n Saved RoboHash named: %@ success: %@ \n", title, @(success));
            }];
        }
    }];
    
    [self.operationQueue addOperation:generateOperation];
}

@end
