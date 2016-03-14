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

@interface RHIDirectoryManager()

@property (nonatomic, strong) NSOperationQueue *fileTaskQueue;
@property (nonatomic, strong) NSCache *cache;

@end

@implementation RHIDirectoryManager

- (id)init
{
    if (self == [super init])
    {
        self.fileTaskQueue = [NSOperationQueue new];
        self.fileTaskQueue.maxConcurrentOperationCount = 1;
        self.fileTaskQueue.name = @"File Task Queue";
        
        self.cache = [NSCache new];
        
        return self;
    }
    
    return nil;
}

- (void)checkForInitialImages
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
                
                BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[[strongSelf pathForFileWithName:string] path]];
                if (!exists)
                    [downloader downloadImage:string];
            }];
        }
    }];
    
    [self.fileTaskQueue addOperation:readOperation];
}

- (UIImage *)loadFileWithName:(NSString *)fileName
{
    NSURL *filePath = [self pathForFileWithName:fileName];
    
    UIImage *cachedImage = [self.cache objectForKey:filePath];
    if (cachedImage)
        return cachedImage;
    
    UIImage *loadedImage = [UIImage imageWithContentsOfFile:[filePath path]];
    if (loadedImage)
        [self.cache setObject:loadedImage forKey:filePath];
    
    return loadedImage;
}

- (void)saveDocumentWithName:(NSString *)name fromTempLocation:(NSURL *)location
{
    NSLog(@"Writing to directory image named %@", name);
    
    NSURL *documentURL = [self pathForFileWithName:name];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:documentURL error:nil];
}

- (NSURL *)pathForFileWithName:(NSString *)fileName
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
    
    return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", fileName]];
}

@end
