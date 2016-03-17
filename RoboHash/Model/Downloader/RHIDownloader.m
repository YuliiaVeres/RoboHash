//
//  RHIDownloader.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/14/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIDownloader.h"
#import "RHIDownloadOperation.h"
#import "RHIRequestManager.h"
#import "RHIDirectoryManager.h"

@interface RHIDownloader()

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end

@implementation RHIDownloader

- (id)init
{
    if (self = [super init])
    {
        self.downloadQueue = [NSOperationQueue new];
        self.downloadQueue.maxConcurrentOperationCount = 5;
        self.downloadQueue.name = @"Download Queue";
    }
    
    return self;
}

- (void)downloadImage:(NSString *)imageName
{
    RHIDownloadOperation *downloadOperation = [[RHIDownloadOperation alloc] initWithImageName:imageName];
    
    [self.downloadQueue addOperation:downloadOperation];
}

@end
