//
//  RHIDownloadOperation.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/14/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIDownloadOperation.h"
#import "RHIRequestManager.h"
#import "RHIDirectoryManager.h"

@interface RHIDownloadOperation()

@property (nonatomic, strong) NSString *imageName;

@property (readwrite, nonatomic, getter = isExecuting) BOOL executing;
@property (readwrite, nonatomic, getter = isFinished) BOOL finished;

@end

@implementation RHIDownloadOperation

@synthesize executing;
@synthesize finished;

- (id)initWithImageName:(NSString *)imageName
{
    if (self = [super init])
    {
        self.imageName = imageName;
    }
    
    return self;
}

- (void)start
{
    if (!self.isCancelled)
        [self main];
    else
        [self finishWork];
}

- (void)main
{
    NSLog(@"\n ---> Started operation for image named: %@ \n", self.imageName);
    
    __weak typeof(self)weakSelf = self;
    
    [[RHIRequestManager sharedInstance] downloadRobotImageForString:self.imageName handler:^(NSURL *tempLocation) {
        
        typeof(weakSelf)strongSelf = weakSelf;
        
        if (!strongSelf.isCancelled && tempLocation)
        {
            [RHIDirectoryManager saveDocumentWithName:strongSelf.imageName fromTempLocation:tempLocation];
            
            NSLog(@"\n +++ Operation finished for image named: %@.", strongSelf.imageName);
        }
        
        [strongSelf finishWork];
    }];
}

- (void)startWork
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    
    self.executing = YES;
    
    [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
}

- (void)finishWork
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    
    self.finished = YES;
    self.executing = NO;
    
    [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
}

- (void)dealloc
{
    NSLog(@"\n\n  *** Operation deallocated for image named : %@ \n", self.imageName);
}

@end
