//
//  RHIDirectoryManager.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/13/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIDirectoryManager.h"
#import "RHIConstants.h"
#import "RHIDownloader.h"
#import "Reachability.h"

@interface RHIDirectoryManager()

@property (nonatomic, strong) NSOperationQueue *fileTaskQueue;
@property (nonatomic, strong) Reachability *reachability;

@end

@implementation RHIDirectoryManager

- (id)init
{
    if (self = [super init])
    {
        self.fileTaskQueue = [NSOperationQueue new];
        self.fileTaskQueue.maxConcurrentOperationCount = 1;
        self.fileTaskQueue.name = @"File Task Queue";
        
        [self configureReachability];
    }
    
    return self;
}

#pragma mark - Configure Network reachability

- (void)configureReachability
{
    self.reachability = [Reachability reachabilityWithHostname:RHIReachabilityHostName];
    
    __weak typeof(self)weakSelf = self;
    self.reachability.reachableBlock = ^(Reachability*reach) {
        
        typeof (weakSelf)strongSelf = weakSelf;
        [strongSelf __checkForInitialImages];
    };
    
    [self.reachability startNotifier];
}

- (void)checkForInitialImages
{
    if (self.reachability.isReachable)
        [self __checkForInitialImages];
    else
        NSLog(@"\n\n No Interent connection");
}

+ (void)saveDocumentWithName:(NSString *)name fromTempLocation:(NSURL *)location
{
    NSLog(@"\n\n --- Writing to directory image named %@ \n", name);
    
    NSURL *documentURL = [self pathForFileWithName:name];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:documentURL error:nil];
}

+ (NSURL *)pathForFileWithName:(NSString *)fileName
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
    
    return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", fileName]];
}

#pragma mark - Private Initial string read and download

- (void)__checkForInitialImages
{
    NSBlockOperation *readOperation = [NSBlockOperation new];
    
    __weak typeof (readOperation)weakOperation = readOperation;
    __weak typeof (self)weakSelf = self;
    
    [readOperation addExecutionBlock:^{
        
        typeof (weakOperation)strongOperation = weakOperation;
        typeof (weakSelf)strongSelf = weakSelf;
        
        if (!strongOperation.isCancelled)
        {
            NSString *stringContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                          pathForResource: RHISringsFileName ofType: @"txt"] encoding:NSUTF8StringEncoding error:nil];
            
            NSArray *strings = [stringContent componentsSeparatedByString:@"\n"];
            strings = [NSArray arrayWithArray:[[NSSet setWithArray:strings] allObjects]];
            
            RHIDownloader *downloader = [RHIDownloader new];
            [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
                
                BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[[[strongSelf class] pathForFileWithName:string] path]];
                
                if (!exists)
                    [downloader downloadImage:string];
            }];
        }
    }];
    
    [self.fileTaskQueue addOperation:readOperation];
}

@end
